import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/initialize_dependencies.dart';
import 'package:critic/blocs/critique_details/critique_details_bloc.dart'
    as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/other_profile/other_profile_bloc.dart'
    as OTHER_PROFILE_BP;
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/user_service.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class CritiqueView extends StatefulWidget {
  const CritiqueView({
    Key? key,
    required this.critique,
    required this.movie,
    required this.user,
    required this.currentUserUid,
  }) : super(key: key);

  /// The critique.
  final CritiqueModel critique;

  /// The movie associated with this critique.
  final MovieModel movie;

  /// The user who posted this critique.
  final UserModel user;

  /// The uid of the current user of the app.
  final String currentUserUid;

  @override
  State createState() => _CritiqueViewState();
}

class _CritiqueViewState extends State<CritiqueView> {
  /// Number of characters for message of the critique.
  int _critiqueMessageCharCount = 75;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locator<UserService>().retrieveUser(uid: widget.critique.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            }

            return Padding(
              padding: EdgeInsets.all(10),
              child: ExpansionTileCard(
                leading: InkWell(
                  onTap: () {
                    if (widget.user.uid == widget.currentUserUid) return;

                    Route route = MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => OTHER_PROFILE_BP.OtherProfileBloc(
                          otherUserID: '${widget.user.uid}',
                        )..add(
                            OTHER_PROFILE_BP.LoadPageEvent(),
                          ),
                        child: OTHER_PROFILE_BP.OtherProfilePage(),
                      ),
                    );

                    Navigator.push(context, route);
                  },
                  child: CachedNetworkImage(
                    imageUrl: '${widget.user.imgUrl}',
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
                  imageUrl: '${widget.movie.poster}',
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
                        '${widget.movie.title}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                          '${widget.user.username}, ${timeago.format(widget.critique.created, allowFromNow: true)}',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
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
                          color: Colors.white,
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
                        Colors.white,
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
