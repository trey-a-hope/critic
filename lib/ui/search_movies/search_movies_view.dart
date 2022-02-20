import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/models/data/search_movies_result_item_model.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/ui/search_movies/search_movies_view_model.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchMoviesView extends StatelessWidget {
  SearchMoviesView({Key? key}) : super(key: key);

  /// Editing controller for message on critique.
  final TextEditingController _textController = TextEditingController();

  /// Key for the scaffold.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Instantiate movie service.
  final MovieService _movieService = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchMoviesViewModel>(
      init: SearchMoviesViewModel(),
      builder: (model) => BasicPage(
        scaffoldKey: _scaffoldKey,
        leftIconButton: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
        child: Column(
          children: [
            TextField(
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline6!.color),
              controller: _textController,
              autocorrect: false,
              onChanged: (text) {
                model.udpateSearchText(text: text);
              },
              cursorColor: Theme.of(context).textTheme.headline5!.color,
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
                    onTap: () {
                      _textController.clear();
                      model.udpateSearchText(text: '');
                    },
                  ),
                  border: InputBorder.none,
                  hintText: 'Enter title here...',
                  hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.headline6!.color)),
            ),
            model.isLoading
                ? Center(child: CircularProgressIndicator())
                : model.errorMessage != null
                    ? Center(child: Text(model.errorMessage!))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: model.movies.length,
                          itemBuilder: (BuildContext context, int index) {
                            final SearchMoviesResultItemModel movie =
                                model.movies[index];

                            return ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: '${movie.poster}',
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  height: 100,
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
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
                                /// Get movie from result.
                                final MovieModel _movie = await _movieService
                                    .getMovieByID(id: movie.imdbID);

                                if (model.returnMovie) {
                                  /// Return movie to previous screen.
                                  Get.back(result: _movie);
                                } else {
                                  /// Go to movie details screen.
                                  Get.toNamed(
                                    Globals.ROUTES_MOVIE_DETAILS,
                                    arguments: {
                                      'movie': _movie,
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
          ],
        ),
        title: 'Search Movie',
      ),
    );
  }
}
