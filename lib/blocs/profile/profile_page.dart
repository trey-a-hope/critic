part of 'profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String _lastID = '';
  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>()
      ..add(
        LoadPageEvent(),
      );
  }

  Future<List<CritiqueModel>> pageFetch(int offset) async {
    List<CritiqueModel> critiques = await locator<CritiqueService>().listByUser(
      uid: _currentUser.uid!,
      limit: PAGE_FETCH_LIMIT,
      lastID: _lastID,
    );

    if (critiques.isEmpty) return critiques;

    _lastID = critiques[critiques.length - 1].id!;

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
          _currentUser = state.currentUser;
          final List<MovieModel> movies = state.movies;

          return Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            body: DefaultTabController(
              length: 2,
              child: Scaffold(
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
                          background: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.darken),
                                image: AssetImage('assets/images/theater.jpeg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Stack(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            locator<UtilService>().heroToImage(
                                              context: context,
                                              imgUrl: _currentUser.imgUrl,
                                              tag: _currentUser.uid!,
                                            );
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: _currentUser.imgUrl,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    GFAvatar(
                                              radius: 40,
                                              backgroundImage: imageProvider,
                                            ),
                                            placeholder: (context, url) =>
                                                Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
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
                                    Text(
                                      '${_currentUser.username}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        bottom: TabBar(
                          isScrollable: true,
                          tabs: [
                            Tab(
                              child: Text(
                                'My Critiques',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Watchlist',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: <Widget>[
                      RefreshIndicator(
                        child: PaginationView<CritiqueModel>(
                          initialLoader: Spinner(),
                          bottomLoader: Spinner(),
                          itemBuilder: (BuildContext context,
                              CritiqueModel critique, int index) {
                            //Send future to fetch the movie and user associated with the critique.
                            Future<UserModel> userFuture =
                                locator<UserService>()
                                    .retrieveUser(uid: critique.uid);
                            Future<MovieModel> movieFuture =
                                locator<MovieService>()
                                    .getMovieByID(id: critique.imdbID);

                            return FutureBuilder(
                              future: Future.wait([userFuture, movieFuture]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<dynamic>> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  default:
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                            'Error ${snapshot.error.toString()}'),
                                      );
                                    }

                                    UserModel user =
                                        snapshot.data![0] as UserModel;
                                    MovieModel movie =
                                        snapshot.data![1] as MovieModel;

                                    return CritiqueView(
                                      movie: movie,
                                      user: user,
                                      critique: critique,
                                      currentUserUid: _currentUser.uid!,
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
                          context.read<ProfileBloc>().add(
                                LoadPageEvent(),
                              );

                          return;
                        },
                      ),
                      movies.isEmpty
                          ? Center(
                              child: Text(
                                'No movies',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : RefreshIndicator(
                              child: ListView.builder(
                                primary: true,
                                shrinkWrap: true,
                                itemCount: movies.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final MovieModel movie = movies[index];
                                  return ListTile(
                                    onTap: () async {
                                      final MovieModel movieModel =
                                          await locator<MovieService>()
                                              .getMovieByID(id: movie.imdbID);

                                      Route route = MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) =>
                                              CREATE_CRITIQUE_BP
                                                  .CreateCritiqueBloc(
                                                      movie: movieModel)
                                                ..add(
                                                  CREATE_CRITIQUE_BP
                                                      .LoadPageEvent(),
                                                ),
                                          child: CREATE_CRITIQUE_BP
                                              .CreateCritiquePage(),
                                        ),
                                      );

                                      Navigator.push(context, route);
                                    },
                                    title: Text(
                                      '${movie.title}',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    leading: CachedNetworkImage(
                                      imageUrl: '${movie.poster}',
                                      imageBuilder: (context, imageProvider) =>
                                          Image(
                                        image: imageProvider,
                                        height: 100,
                                      ),
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  );
                                },
                              ),
                              onRefresh: () async {
                                context.read<ProfileBloc>().add(
                                      LoadPageEvent(),
                                    );

                                return;
                              },
                            )
                    ],
                  ),
                ),
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
