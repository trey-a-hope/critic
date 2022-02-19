import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/blocs/critique_details/critique_details_bloc.dart'
    as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/other_profile/other_profile_bloc.dart'
    as OTHER_PROFILE_BP;
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class CritiqueViewModel extends StatefulWidget {
  const CritiqueViewModel({
    Key? key,
    required this.critique,
  }) : super(key: key);

  /// The critique.
  final CritiqueModel critique;

  @override
  _CritiqueViewModelState createState() => _CritiqueViewModelState();
}

class _CritiqueViewModelState extends State<CritiqueViewModel> {
  /// The movie associated with this critique.
  MovieModel? movie;

  /// The user who posted this critique.
  UserModel? user;

  /// Number of characters for message of the critique.
  int _critiqueMessageCharCount = 75;

  /// Instantiate movie service.
  MovieService _movieService = Get.find();

  /// Instantiate user service.
  UserService _userService = Get.find();

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// Array that holds api calls for fetching the movie and user of this critique.
  List<Future> futures = [];

  @override
  void initState() {
    /// Add service call for fetching movie.
    futures.add(_movieService.getMovieByID(id: widget.critique.imdbID));

    /// Add service call for fetching user.
    futures.add(_userService.retrieveUser(uid: widget.critique.uid));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(futures),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            }

            /// Set result to movie object.
            MovieModel movie = snapshot.data[0];

            /// Set result to user object.
            UserModel user = snapshot.data[1];

            return Padding(
              padding: EdgeInsets.all(10),
              child: ExpansionTileCard(
                leading: InkWell(
                  onTap: () {
                    /// If the current user is the one who posted this critique, void this action.
                    if (user.uid == _getStorage.read('uid')) return;

                    Route route = MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => OTHER_PROFILE_BP.OtherProfileBloc(
                          otherUserID: '${user.uid}',
                        )..add(
                            OTHER_PROFILE_BP.LoadPageEvent(),
                          ),
                        child: OTHER_PROFILE_BP.OtherProfilePage(),
                      ),
                    );

                    Navigator.push(context, route);
                  },
                  child: CachedNetworkImage(
                    imageUrl: '${user.imgUrl}',
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                trailing: CachedNetworkImage(
                  imageUrl: '${movie.poster}',
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                title: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${movie.title}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                          '${user.username}, ${timeago.format(widget.critique.created, allowFromNow: true)}',
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                    ],
                  ),
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      widget.critique.message.length > _critiqueMessageCharCount
                          ? '"${widget.critique.message}\"'
                                  .substring(0, _critiqueMessageCharCount + 1) +
                              '..."'
                          : '"${widget.critique.message}\"',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).canvasColor),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.black,
                      ),
                    ),
                    child: Text('Read Full Review'),
                    onPressed: () {
                      Route route = MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              CRITIQUE_DETAILS_BP.CritiqueDetailsBloc(
                            critiqueID: widget.critique.id!,
                          )..add(
                                  CRITIQUE_DETAILS_BP.LoadPageEvent(),
                                ),
                          child: CRITIQUE_DETAILS_BP.CritiqueDetailsPage(),
                        ),
                      );

                      Navigator.push(context, route);
                    },
                  )
                ],
              ),
            );
        }
      },
    );
  }
}
