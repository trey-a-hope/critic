import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/ui/critique_widget/critique_widget_view.dart';
import 'package:critic/ui/critique_widget/loading_critique_widget_view.dart';
import 'package:critic/ui/movie_details/movie_details_view_model.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MovieDetailsViewModel>(
      init: MovieDetailsViewModel(),
      builder: (model) {
        /// The movie.
        MovieModel movie = model.movie;

        /// All critiques for this movie.
        List<CritiqueModel>? critiques = model.critiques;

        /// Flag for if the movie is in the user's watchlist.
        bool movieInWatchlist = model.movieInWatchlist;

        return model.isLoading
            ? Scaffold(body: Center(child: CircularProgressIndicator()))
            : BasicPage(
                leftIconButton: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    Get.back();
                  },
                ),
                rightIconButton: IconButton(
                  icon: Icon(movieInWatchlist
                      ? Icons.bookmark
                      : Icons.bookmark_outline),
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
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
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
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  Divider(),
                                  Text(
                                    '${movie.plot}',
                                    style:
                                        Theme.of(context).textTheme.headline5,
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Actors',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      Text(
                                        '${movie.actors}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Director',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      Text(
                                        '${movie.director}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Genres',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      Text(
                                        '${movie.genre}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Rated',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      Text(
                                        '${movie.rated}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Released',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      Text(
                                        '${movie.released}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('IMDB Rating',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      Text(
                                        '${movie.imdbRating} (${movie.imdbVotes} votes)',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Critiques (${critiques == null ? '0' : critiques.length})',
                            ),
                          ),
                        ],
                      ),
                    ),
                    model.critiques == null
                        ? LoadingCritiqueWidgetView()
                        : Container(
                            height: 270,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: critiques!.length,
                              itemBuilder: (context, index) {
                                CritiqueModel critique = critiques[index];
                                return Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child:
                                        CritiqueWidgetView(critique: critique),
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
