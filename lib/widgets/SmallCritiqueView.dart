import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/critiqueDetails/Bloc.dart' as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/createCritique/Bloc.dart' as CREATE_CRITIQUE_BP;

class SmallCritiqueView extends StatefulWidget {
  const SmallCritiqueView({
    Key key,
    @required this.critique,
    @required this.currentUser,
  }) : super(key: key);

  final CritiqueModel critique;
  final UserModel currentUser;

  @override
  State createState() => SmallCritiqueViewState(
        critique: critique,
        currentUser: currentUser,
      );
}

class SmallCritiqueViewState extends State<SmallCritiqueView> {
  SmallCritiqueViewState({
    @required this.critique,
    @required this.currentUser,
  });

  final CritiqueModel critique;
  final UserModel currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locator<UserService>().retrieveUser(uid: critique.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return critiqueView(
              context: context,
              userWhoPosted: UserModel(
                imgUrl: DUMMY_PROFILE_PHOTO_URL,
                email: null,
                modified: null,
                created: null,
                uid: null,
                username: 'John Doe',
                critiqueCount: null,
                fcmToken: null,
                watchListCount: null,
              ),
            );
            break;
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
    @required BuildContext context,
    @required UserModel userWhoPosted,
  }) {
    return ListTile(
      tileColor: Theme.of(context).canvasColor,
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CRITIQUE_DETAILS_BP.CritiqueDetailsBloc(
              critiqueModel: critique,
            )..add(
                CRITIQUE_DETAILS_BP.LoadPageEvent(),
              ),
            child: CRITIQUE_DETAILS_BP.CritiqueDetailsPage(),
          ),
        );

        Navigator.push(context, route);
      },
      title: Text('\"${critique.message}\"',
          style: Theme.of(context).textTheme.headline6),
      subtitle: Text(
        '\n${critique.movieTitle} - ${userWhoPosted.username}, ${timeago.format(critique.created, allowFromNow: true)}',
        style: Theme.of(context).textTheme.headline5,
      ),
      trailing: InkWell(
        onTap: () {
          if (userWhoPosted.uid == currentUser.uid) return;

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
          final MovieModel movieModel =
              await locator<MovieService>().getMovieByID(id: critique.imdbID);

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
          imageUrl: '${critique.moviePoster}',
          imageBuilder: (context, imageProvider) => Image(
            image: imageProvider,
            height: 100,
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
