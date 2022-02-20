part of 'other_profile_bloc.dart';

class OtherProfilePage extends StatefulWidget {
  @override
  State createState() => OtherProfilePageState();
}

class OtherProfilePageState extends State<OtherProfilePage>
    implements OTHER_PROFILE_BP.OtherProfileBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _lastID = '';
  late UserModel _otherUser;

  @override
  void initState() {
    context
        .read<OTHER_PROFILE_BP.OtherProfileBloc>()
        .setDelegate(delegate: this);
    super.initState();
  }

  Future<List<CritiqueModel>> pageFetch(int offset) async {
    List<CritiqueModel> critiques = await locator<CritiqueService>().listByUser(
      uid: _otherUser.uid,
      limit: PAGE_FETCH_LIMIT,
      lastID: _lastID,
    );

    if (critiques.isEmpty) return critiques;

    _lastID = critiques[critiques.length - 1].id!;

    return critiques;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileBloc, OTHER_PROFILE_BP.OtherProfileState>(
      builder:
          (BuildContext context, OTHER_PROFILE_BP.OtherProfileState state) {
        if (state is OTHER_PROFILE_BP.LoadingState) {
          return Scaffold(
            body: Spinner(),
          );
        }

        if (state is OTHER_PROFILE_BP.LoadedState) {
          _otherUser = state.otherUser;
          final UserModel currentUser = state.currentUser;

          return Scaffold(
            key: _scaffoldKey,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: colorNavy,
                    expandedHeight: 300.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        '${_otherUser.username}',
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
                            InkWell(
                              onTap: () {
                                locator<UtilService>().heroToImage(
                                  context: context,
                                  imgUrl: _otherUser.imgUrl,
                                  tag: _otherUser.uid,
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: '${_otherUser.imgUrl}',
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 40,
                                  backgroundImage: imageProvider,
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            SizedBox(height: 10),
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
                      int index) {
                    //Send future to fetch the movie and user associated with the critique.
                    Future<UserModel> userFuture =
                        locator<UserService>().retrieveUser(uid: critique.uid);
                    Future<MovieModel> movieFuture = locator<MovieService>()
                        .getMovieByID(id: critique.imdbID);

                    return FutureBuilder(
                      future: Future.wait([userFuture, movieFuture]),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return CircularProgressIndicator();
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                child:
                                    Text('Error ${snapshot.error.toString()}'),
                              );
                            }

                            UserModel user = snapshot.data![0] as UserModel;
                            MovieModel movie = snapshot.data![1] as MovieModel;

                            return CritiqueView(
                              movie: movie,
                              user: user,
                              critique: critique,
                              currentUserUid: currentUser.uid,
                            );
                        }
                      },
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
                onRefresh: () async {
                  context.read<OTHER_PROFILE_BP.OtherProfileBloc>().add(
                        OTHER_PROFILE_BP.LoadPageEvent(),
                      );
                },
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  @override
  void showMessage({required String message}) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }

  @override
  void navigateHome() {
    Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );
  }
}
