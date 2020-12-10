import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/createCritique/Bloc.dart' as CREATE_CRITIQUE_BP;
import 'package:critic/models/MovieModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class WatchlistPage extends StatefulWidget {
  @override
  State createState() => WatchlistPageState();
}

class WatchlistPageState extends State<WatchlistPage>
    implements WatchlistBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      limit: _watchlistBloc.limit,
      startAfterDocument: _watchlistBloc.startAfterDocument,
    );

    //Return an empty list if there are no new documents.
    if (documentSnapshots.isEmpty) {
      return List<MovieModel>();
    }

    _watchlistBloc.startAfterDocument =
        documentSnapshots[documentSnapshots.length - 1];

    List<MovieModel> movies = List<MovieModel>();

    //Convert documents to template models.
    documentSnapshots.forEach((documentSnapshot) {
      MovieModel movieModel = MovieModel.fromDoc(ds: documentSnapshot);
      movies.add(movieModel);
    });

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
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
                  color: Colors.grey,
                ),
                Text(
                  'No movies in your watchlist.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Search some movies to add.')
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
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                subtitle: Text(
                  '${timeago.format(movie.addedToWatchList, allowFromNow: true)}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                ),
                leading: Image.network(
                  movie.poster,
                  height: 100,
                ),
              );
            },
          );
        }

        return Center(
          child: Text('You should NEVER see this.'),
        );
      },
    );
  }

  @override
  void showMessage({
    @required String message,
  }) {
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }
}