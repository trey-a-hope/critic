import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/critiqueDetails/Bloc.dart' as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/createCritique/Bloc.dart' as CREATE_CRITIQUE_BP;
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallCritiqueView extends StatefulWidget {
  const SmallCritiqueView({
    Key key,
    @required this.critique,
    @required this.currentUser,
  }) : super(key: key);

  final CritiqueModel critique;
  final UserModel currentUser;

  @override
  State createState() => SmallCritiqueViewState();
}

class SmallCritiqueViewState extends State<SmallCritiqueView> {
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
                    critiqueID: widget.critique.id,
                  )..add(
                      CRITIQUE_DETAILS_BP.LoadPageEvent(),
                    ),
                  child: CRITIQUE_DETAILS_BP.CritiqueDetailsPage(),
                ),
              );

              Navigator.push(context, route);
            },
            title: Text('\"${widget.critique.message}\"',
                style: Theme.of(context).textTheme.headline6),
            subtitle: Text(
              '\n${widget.critique.movie.title} - ${userWhoPosted.username}, ${timeago.format(widget.critique.created, allowFromNow: true)}',
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
                imageUrl: '${widget.critique.movie.poster}',
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
