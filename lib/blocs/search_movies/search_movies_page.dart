part of 'search_movies_bloc.dart';

class SearchMoviesPage extends StatelessWidget {
  final bool returnMovie;

  SearchMoviesPage({@required this.returnMovie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Critique'),
      ),
      body: Column(
        children: [
          _SearchBar(),
          _SearchBody(
            returnMovie: returnMovie,
          )
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _textController = TextEditingController();
  SearchMoviesBloc _searchMoviesBloc;

  @override
  void initState() {
    super.initState();
    _searchMoviesBloc = BlocProvider.of<SearchMoviesBloc>(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Theme.of(context).textTheme.headline6.color),
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        _searchMoviesBloc.add(
          TextChangedEvent(text: text),
        );
      },
      cursorColor: Theme.of(context).textTheme.headline5.color,
      decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
          ),
          suffixIcon: GestureDetector(
            child: Icon(
              Icons.clear,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: _onClearTapped,
          ),
          border: InputBorder.none,
          hintText: 'Enter a search term',
          hintStyle:
              TextStyle(color: Theme.of(context).textTheme.headline6.color)),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _searchMoviesBloc.add(TextChangedEvent(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  final bool returnMovie;

  _SearchBody({@required this.returnMovie});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
      builder: (BuildContext context, SearchMoviesState state) {
        if (state is SearchMoviesStateEmpty) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_movies,
                  color: Colors.grey,
                  size: 100,
                ),
                Text('Please enter a movie name to begin...',
                    style: Theme.of(context).textTheme.headline6),
              ],
            ),
          );
        }

        if (state is SearchMoviesStateLoading) {
          return Spinner();
        }

        if (state is SearchMoviesStateError) {
          return Expanded(
            child: Center(
              child: Text(
                state.error.message,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          );
        }

        if (state is SearchMoviesStateSuccess) {
          final List<SearchMoviesResultItemModel> movies = state.movies;

          return Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                final SearchMoviesResultItemModel movie = movies[index];

                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: '${movie.poster}',
                    imageBuilder: (context, imageProvider) => Image(
                      image: imageProvider,
                      height: 100,
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(
                    '${movie.title}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    'Year: ${movie.year}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).iconTheme.color,
                  ),
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

                    if (returnMovie) {
                      Navigator.pop(context, movieModel);
                    } else {
                      Navigator.push(context, route);
                    }
                  },
                );
              },
            ),
          );
        }

        return Center(
          child: Text('YOU SHOULD NEVER SEE THIS...'),
        );
      },
    );
  }
}
