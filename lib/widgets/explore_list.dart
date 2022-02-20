import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pagination_view/pagination_view.dart';
import '../constants.dart';
import '../initialize_dependencies.dart';
import 'Spinner.dart';
import 'critique_view.dart';

class ExploreList extends StatelessWidget {
  final UserModel currentUser;
  final String genre;
  final VoidCallback onRefresh;

  String lastID = '';

  ExploreList({
    Key? key,
    required this.currentUser,
    required this.genre,
    required this.onRefresh,
  }) : super(key: key);

  Future<List<CritiqueModel>> pageFetch(int offset) async {
    List<CritiqueModel> critiques;

    critiques = [];

    critiques = await locator<CritiqueService>().listByGenre(
      genre: genre,
      limit: PAGE_FETCH_LIMIT,
      lastID: lastID,
    );

    if (critiques.isEmpty) return critiques;

    lastID = critiques[critiques.length - 1].id!;

    return critiques;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PaginationView<CritiqueModel>(
        initialLoader: Spinner(),
        bottomLoader: Spinner(),
        itemBuilder: (BuildContext context, CritiqueModel critique, int index) {
          //Send future to fetch the movie and user associated with the critique.
          Future<UserModel> userFuture =
              locator<UserService>().retrieveUser(uid: critique.uid);
          Future<MovieModel> movieFuture =
              locator<MovieService>().getMovieByID(id: critique.imdbID);

          return FutureBuilder(
            future: Future.wait([userFuture, movieFuture]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error ${snapshot.error.toString()}'),
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
        paginationViewType: PaginationViewType.listView,
      ),
      onRefresh: () async {
        lastID = '';
        onRefresh();
        return;
      },
    );
  }
}
