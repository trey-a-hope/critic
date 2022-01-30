import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/blocs/critique_details/critique_details_bloc.dart'
    as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/create_critique/create_critique_bloc.dart'
    as CREATE_CRITIQUE_BP;
import 'package:critic/blocs/other_profile/other_profile_bloc.dart'
    as OTHER_PROFILE_BP;
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallCritiqueView extends StatefulWidget {
  const SmallCritiqueView({
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
  State createState() => SmallCritiqueViewState();
}

class SmallCritiqueViewState extends State<SmallCritiqueView> {
  int _critiqueMessageCharCount = 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String message = widget.critique.message.length > _critiqueMessageCharCount
        ? widget.critique.message.substring(0, _critiqueMessageCharCount - 1) +
            '...'
        : widget.critique.message;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            tileColor: Theme.of(context).canvasColor,
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CRITIQUE_DETAILS_BP.CritiqueDetailsBloc(
                    critiqueID: widget.critique.id!,
                  )..add(
                      CRITIQUE_DETAILS_BP.LoadPageEvent(),
                    ),
                  child: CRITIQUE_DETAILS_BP.CritiqueDetailsPage(),
                ),
              );

              Navigator.push(context, route);
            },
            title: Text('\"$message\"',
                style: Theme.of(context).textTheme.headline6),
            subtitle: Text(
              '\n${widget.movie.title} - ${widget.user.username}, ${timeago.format(widget.critique.created, allowFromNow: true)}',
              style: Theme.of(context).textTheme.headline5,
            ),
            trailing: InkWell(
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
            leading: InkWell(
              onTap: () async {
                final MovieModel movieModel = await locator<MovieService>()
                    .getMovieByID(id: widget.movie.imdbID);

                Route route = MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        CREATE_CRITIQUE_BP.CreateCritiqueBloc(movie: movieModel)
                          ..add(
                            CREATE_CRITIQUE_BP.LoadPageEvent(),
                          ),
                    child: CREATE_CRITIQUE_BP.CreateCritiquePage(),
                  ),
                );

                Navigator.push(context, route);
              },
              child: CachedNetworkImage(
                imageUrl: '${widget.movie.poster}',
                imageBuilder: (context, imageProvider) => Image(
                  image: imageProvider,
                  height: 200,
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          )
        ],
      ),
    );
  }
}
