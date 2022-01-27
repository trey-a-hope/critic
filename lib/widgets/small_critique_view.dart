import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/blocs/critique_details/critique_details_bloc.dart'
    as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/create_critique/create_critique_bloc.dart'
    as CREATE_CRITIQUE_BP;
import 'package:critic/blocs/other_profile/other_profile_bloc.dart'
    as OTHER_PROFILE_BP;
import 'package:critic/models/critique_model.dart';
import 'package:critic/models/movie_model.dart';
import 'package:critic/models/user_model.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallCritiqueView extends StatefulWidget {
  const SmallCritiqueView({
    Key? key,
    required this.critique,
    required this.currentUser,
  }) : super(key: key);

  final CritiqueModel critique;
  final UserModel currentUser;

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

            UserModel userWhoPosted = snapshot.data;

            return critiqueView(
              context: context,
              userWhoPosted: userWhoPosted,
            );
        }
      },
    );
  }

  Widget critiqueView({
    required BuildContext context,
    required UserModel userWhoPosted,
  }) {
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
              '\n${widget.critique.movie!.title} - ${userWhoPosted.username}, ${timeago.format(widget.critique.created, allowFromNow: true)}',
              style: Theme.of(context).textTheme.headline5,
            ),
            trailing: InkWell(
              onTap: () {
                if (userWhoPosted.uid == widget.currentUser.uid) return;

                Route route = MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => OTHER_PROFILE_BP.OtherProfileBloc(
                      otherUserID: '${userWhoPosted.uid}',
                    )..add(
                        OTHER_PROFILE_BP.LoadPageEvent(),
                      ),
                    child: OTHER_PROFILE_BP.OtherProfilePage(),
                  ),
                );

                Navigator.push(context, route);
              },
              child: CachedNetworkImage(
                imageUrl: '${userWhoPosted.imgUrl}',
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
                    .getMovieByID(id: widget.critique.imdbID);

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
                imageUrl: '${widget.critique.movie!.poster}',
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
