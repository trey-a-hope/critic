part of 'profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String _lastID = '';

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>()
      ..add(
        LoadPageEvent(),
      );
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

          return Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
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
                child: PaginationView<CritiqueModel>(
                  initialLoader: Spinner(),
                  bottomLoader: Spinner(),
                  itemBuilder: (BuildContext context, CritiqueModel critique,
                          int index) =>
                      CritiqueView(
                    critique: critique,
                    currentUser: currentUser,
                  ),
                  pageFetch: (int offset) async {
                    List<CritiqueModel> critiques =
                        await locator<CritiqueService>().listByUser(
                      uid: currentUser.uid!,
                      limit: PAGE_FETCH_LIMIT,
                      lastID: _lastID,
                    );

                    if (critiques.isEmpty) return critiques;

                    _lastID = critiques[0].id!;

                    return critiques;
                  },
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
                onRefresh: () async {
                  context.read<ProfileBloc>().add(
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
        builder: (BuildContext buildContext) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () {
                  Navigator.pop(buildContext);
                  context.read<ProfileBloc>().add(
                        UploadImageEvent(imageSource: ImageSource.camera),
                      );
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Choose From Gallery'),
                onPressed: () {
                  Navigator.pop(buildContext);
                  context.read<ProfileBloc>().add(
                        UploadImageEvent(imageSource: ImageSource.gallery),
                      );
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(buildContext),
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
                context.read<ProfileBloc>().add(
                      UploadImageEvent(imageSource: ImageSource.camera),
                    );
              },
            ),
            SimpleDialogOption(
              child: Text('Choose From Gallery'),
              onPressed: () {
                Navigator.pop(context);
                context.read<ProfileBloc>().add(
                      UploadImageEvent(imageSource: ImageSource.gallery),
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
      },
    );
  }
}
