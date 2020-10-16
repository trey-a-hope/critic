import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesBloc.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/SearchMoviesResultItem.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'SearchMoviesEvent.dart';
import 'SearchMoviesState.dart';
import 'package:critic/blocs/createCritique/Bloc.dart' as CREATE_CRITIQUE_BP;

class SearchMoviesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_SearchBar(), _SearchBody()],
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
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        _searchMoviesBloc.add(
          TextChangedEvent(text: text),
        );
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          child: Icon(Icons.clear),
          onTap: _onClearTapped,
        ),
        border: InputBorder.none,
        hintText: 'Enter a search term',
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _searchMoviesBloc.add(TextChangedEvent(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
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
                Text('Please enter a movie name to begin...')
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
              child: Text(state.error.message),
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
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(movie.poster),
                  ),
                  title: Text('${movie.title}'),
                  subtitle: Text('Year: ${movie.year}'),
                  trailing: Icon(Icons.chevron_right),
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
