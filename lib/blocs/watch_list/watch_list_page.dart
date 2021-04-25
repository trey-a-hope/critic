part of 'watch_list_bloc.dart';

class WatchlistPage extends StatefulWidget {
  @override
  State createState() => WatchlistPageState();
}

class WatchlistPageState extends State<WatchlistPage>
    implements WatchlistBlocDelegate {
  WatchlistBloc _watchlistBloc;

  @override
  void initState() {
    _watchlistBloc = BlocProvider.of<WatchlistBloc>(context);
    _watchlistBloc.setDelegate(delegate: this);
    super.initState();
  }

  Future<List<MovieModel>> pageFetch(int offset) async {
    //Fetch template documents.
    List<DocumentSnapshot> documentSnapshots =
        await locator<UserService>().retrieveMoviesFromWatchlist(
      uid: _watchlistBloc.currentUser.uid,
      limit: PAGE_FETCH_LIMIT,
      startAfterDocument: _watchlistBloc.startAfterDocument,
    );

    //Return an empty list if there are no new documents.
    if (documentSnapshots.isEmpty) {
      return [];
    }

    _watchlistBloc.startAfterDocument =
        documentSnapshots[documentSnapshots.length - 1];

    List<MovieModel> movies = [];

    //Convert documents to template models.
    documentSnapshots.forEach((documentSnapshot) {
      MovieModel movieModel = MovieModel.fromDoc(ds: documentSnapshot);
      movies.add(movieModel);
    });

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is EmptyWatchlistState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.movieSearch,
                    size: 100,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Text(
                    'Currently no movies in your watchlist.',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            );
          }

          if (state is LoadedState) {
            final List<MovieModel> movies = state.movies;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                final MovieModel movie = movies[index];
                return ListTile(
                  onTap: () async {
                    final MovieModel movieModel = await locator<MovieService>()
                        .getMovieByID(id: movie.imdbID);

                    Route route = MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) =>
                            CREATE_CRITIQUE_BP.CreateCritiqueBloc(
                                movie: movieModel)
                              ..add(
                                CREATE_CRITIQUE_BP.LoadPageEvent(),
                              ),
                        child: CREATE_CRITIQUE_BP.CreateCritiquePage(),
                      ),
                    );

                    Navigator.push(context, route);
                  },
                  title: Text(
                    '${movie.title}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    '${timeago.format(movie.addedToWatchList, allowFromNow: true)}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  leading: CachedNetworkImage(
                    imageUrl: '${movie.poster}',
                    imageBuilder: (context, imageProvider) => Image(
                      image: imageProvider,
                      height: 100,
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              },
            );
          }

          return Center(
            child: Text('You should NEVER see this.'),
          );
        },
      ),
    );
  }

  @override
  void showMessage({
    @required String message,
  }) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }
}
