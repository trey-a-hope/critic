import 'package:critic/blocs/searchMovies/SearchMoviesBloc.dart';
import 'package:critic/models/SearchMoviesResultItem.dart';
import 'package:critic/pages/MovieDetailsPage.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'SearchMoviesEvent.dart';
import 'SearchMoviesState.dart';

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
            child: Center(
              child: Text('Please enter a movie name to begin...'),
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsPage(
                          imdbID: movie.imdbID,
                        ),
                      ),
                    );
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
