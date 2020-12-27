part of 'profile_bloc.dart';



class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = BlocProvider.of<ProfileBloc>(context)
      ..add(
        LoadPageEvent(),
      );
  }

  Future<List<CritiqueModel>> pageFetch(int offset) async {
    //Fetch template documents.
    List<DocumentSnapshot> documentSnapshots =
        await locator<CritiqueService>().retrieveCritiquesFromFirebase(
      uid: _profileBloc.currentUser.uid,
      limit: _profileBloc.limit,
      startAfterDocument: _profileBloc.startAfterDocument,
    );

    //Return an empty list if there are no new documents.
    if (documentSnapshots.isEmpty) {
      return [];
    }

    _profileBloc.startAfterDocument =
        documentSnapshots[documentSnapshots.length - 1];

    List<CritiqueModel> critiques = [];

    //Convert documents to template models.
    documentSnapshots.forEach((documentSnapshot) {
      CritiqueModel critiqueModel = CritiqueModel.fromDoc(ds: documentSnapshot);
      critiques.add(critiqueModel);
    });

    return critiques;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (BuildContext context, ProfileState state) {
        if (state is LoadingState) {
          return Spinner();
        }

        if (state is LoadedState) {
          final UserModel currentUser = state.currentUser;
          final int followerCount = state.followerCount;
          final int followingCount = state.followingCount;

          return Scaffold(
            backgroundColor: Colors.white,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: colorNavy,
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        '${currentUser.username}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                            image: AssetImage('assets/images/theater.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: '${currentUser.imgUrl}',
                                  imageBuilder: (context, imageProvider) =>
                                      GFAvatar(
                                    radius: 40,
                                    backgroundImage: imageProvider,
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                Positioned(
                                  bottom: 1,
                                  right: 1,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.red,
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(
                                          MdiIcons.camera,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          showSelectImageDialog();
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      '${currentUser.critiqueCount} Critiques',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: InkWell(
                                      child: Text(
                                        '$followerCount Followers',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Route route = MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => FOLLOWERS_BP.FollowersBloc(
                                                    user: currentUser)
                                              ..add(
                                                FOLLOWERS_BP.LoadPageEvent(),
                                              ),
                                            child: FOLLOWERS_BP.FollowersPage(),
                                          ),
                                        );

                                        Navigator.push(context, route);
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: InkWell(
                                      child: Text(
                                        '$followingCount Followings',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Route route = MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => FOLLOWINGS_BP
                                                .FollowingsBloc(
                                                    user: currentUser)
                                              ..add(
                                                FOLLOWINGS_BP.LoadPageEvent(),
                                              ),
                                            child:
                                                FOLLOWINGS_BP.FollowingsPage(),
                                          ),
                                        );

                                        Navigator.push(context, route);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                child: PaginationList<CritiqueModel>(
                  onLoading: Spinner(),
                  onPageLoading: Spinner(),
                  separatorWidget: Divider(
                    height: 0,
                    color: Theme.of(context).dividerColor,
                  ),
                  itemBuilder: (BuildContext context, CritiqueModel critique) {
                    return SmallCritiqueView(
                      critique: critique,
                      currentUser: currentUser,
                    );
                  },
                  pageFetch: pageFetch,
                  onError: (dynamic error) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          'Error',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  onEmpty: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.movieEdit,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          '$MESSAGE_EMPTY_CRITIQUES',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ),
                onRefresh: () {
                  _profileBloc.add(
                    LoadPageEvent(),
                  );

                  return;
                },
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  showSelectImageDialog() {
    return Platform.isIOS ? iOSBottomSheet() : androidDialog();
  }

  iOSBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () {
                  Navigator.pop(context);
                  _profileBloc.add(
                    UploadImageEvent(
                        imageSource: ImageSource.camera),
                  );
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Choose From Gallery'),
                onPressed: () {
                  Navigator.pop(context);
                  _profileBloc.add(
                    UploadImageEvent(
                        imageSource: ImageSource.gallery),
                  );
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add Photo'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  Navigator.pop(context);
                  _profileBloc.add(
                    UploadImageEvent(
                        imageSource: ImageSource.camera),
                  );
                },
              ),
              SimpleDialogOption(
                child: Text('Choose From Gallery'),
                onPressed: () {
                  Navigator.pop(context);
                  _profileBloc.add(
                  UploadImageEvent(
                        imageSource: ImageSource.gallery),
                  );
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
