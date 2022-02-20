import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/models/ui/small_critique_view_model.dart';
import 'package:critic/ui/movie_details/movie_details_view_model.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///TODO: Make this UI cleaner.
class MovieDetailsView extends StatelessWidget {
  MovieDetailsView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MovieDetailsViewModel>(
      init: MovieDetailsViewModel(),
      builder: (model) {
        /// The movie.
        MovieModel movie = model.movie;

        /// All critiques for this movie.
        List<CritiqueModel> critiques = model.critiques;

        /// Flag for if the movie is in the user's watchlist.
        bool movieInWatchlist = model.movieInWatchlist;

        return BasicPage(
          scaffoldKey: _scaffoldKey,
          leftIconButton: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              Get.back();
            },
          ),
          rightIconButton: IconButton(
            icon: Icon(
                movieInWatchlist ? Icons.bookmark : Icons.bookmark_outline),
            onPressed: () async {
              if (movieInWatchlist) {
                await model.removeMovieFromWatchList();
                Get.snackbar(
                  'Got it.',
                  'Movie removed from watchlist.',
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                model.addMovieToWatchList();
                Get.snackbar(
                  'Got it.',
                  'Movie added to watchlist.',
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
          ),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                margin: EdgeInsets.only(bottom: 20.0),
                height: 300,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: '${movie.poster}',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 10.0)
                            ],
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SelectableText(
                              movie.title,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Divider(),
                            Text(
                              '${movie.plot}',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          color: Theme.of(context).canvasColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(5.0, 5.0),
                                blurRadius: 10.0)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                'Actors: ${movie.actors}',
                style: Theme.of(context).textTheme.headline4,
              ),
              Divider(),
              Text(
                'Director: ${movie.director}',
                style: Theme.of(context).textTheme.headline4,
              ),
              Divider(),
              Text(
                'Genres: ${movie.genre}',
                style: Theme.of(context).textTheme.headline4,
              ),
              Divider(),
              Text(
                'Rated: ${movie.rated}',
                style: Theme.of(context).textTheme.headline4,
              ),
              Divider(),
              Text(
                'Released: ${movie.released}',
                style: Theme.of(context).textTheme.headline4,
              ),
              Divider(),
              Text(
                'Writer: ${movie.writer}',
                style: Theme.of(context).textTheme.headline4,
              ),
              Divider(),
              Text(
                'Critiques - ${critiques.length}',
                style: Theme.of(context).textTheme.headline4,
              ),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: critiques.length,
                  itemBuilder: (context, index) {
                    CritiqueModel critique = critiques[index];
                    return Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SmallCritiqueViewModel(critique: critique),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          title: 'Details',
        );
      },
    );
  }
}