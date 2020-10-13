import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/otherProfile/Bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'RoundedContainer.dart';

class CritiqueView extends StatefulWidget {
  const CritiqueView({
    Key key,
    @required this.critique,
    @required this.currentUser,
  }) : super(key: key);

  final CritiqueModel critique;
  final UserModel currentUser;

  @override
  State createState() => CritiqueViewState(
        critique: critique,
        currentUser: currentUser,
      );
}

class CritiqueViewState extends State<CritiqueView> {
  CritiqueViewState({
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
    Future getUserFuture =
        locator<UserService>().retrieveUser(uid: critique.userID);
    Future getMovieFuture =
        locator<MovieService>().getMovieByID(id: critique.imdbID);

    Future futures = Future.wait(
      [
        getUserFuture,
        getMovieFuture,
      ],
    );

    return FutureBuilder(
      future: futures,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return buildBlankCriticView(
              context: context,
            );
            break;
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            }

            UserModel userWhoPosted = snapshot.data[0];
            MovieModel movie = snapshot.data[1];

            return movieView(
              context: context,
              movie: movie,
              userWhoPosted: userWhoPosted,
            );

          // return buildCritiqueView(
          //   context: context,
          //   movie: movie,
          //   userWhoPosted: userWhoPosted,
          // );
        }
      },
    );
  }

  Widget movieView({
    @required BuildContext context,
    @required UserModel userWhoPosted,
    @required MovieModel movie,
  }) {
    return InkWell(
      onTap: () {
        locator<ModalService>().showAlert(
          context: context,
          title: 'To Do',
          message: 'Open critique details page.',
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        margin: EdgeInsets.only(bottom: 20.0),
        height: 300,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('${movie.poster}'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 10.0)
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${movie.title}',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text("\"${critique.message}\"",
                        style: TextStyle(color: Colors.grey.shade900, fontSize: 12.0)),
                    Spacer(),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            '${userWhoPosted.imgUrl}',
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${userWhoPosted.username}',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  color: Colors.white,
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
    );
  }

  Widget buildBlankCriticView({
    @required BuildContext context,
  }) {
    return RoundedContainer(
      padding: const EdgeInsets.all(0),
      margin: EdgeInsets.all(10),
      height: 225,
      child: Row(
        children: <Widget>[
          Container(
            width: 130,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(DUMMY_POSTER_IMG_URL),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          'Dummy Movie',
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Year: "),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '1992',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                  Divider(),
                  Text(
                    "No message yet.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      InkWell(
                        child: CircleAvatar(
                          radius: 25,
                          child: Text('T'),
                        ),
                        onTap: () {},
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${timeago.format(DateTime.now())}',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        tooltip: 'Report This Post',
                        onPressed: () async {},
                        color: Colors.red,
                        icon: Icon(Icons.report),
                        iconSize: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCritiqueView({
    @required BuildContext context,
    @required UserModel userWhoPosted,
    @required MovieModel movie,
  }) {
    return RoundedContainer(
      padding: const EdgeInsets.all(0),
      margin: EdgeInsets.all(10),
      height: 200,
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(movie.poster),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          '${movie.title}',
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Year: "),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${movie.year}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                  Divider(),
                  Text(
                    "\"${critique.message}\"",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      InkWell(
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            userWhoPosted.imgUrl,
                          ),
                        ),
                        onTap: () {
                          Route route = MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => OtherProfileBloc(
                                otherUserID: userWhoPosted.uid,
                              )..add(
                                  LoadPageEvent(),
                                ),
                              child: OtherProfilePage(),
                            ),
                          );

                          Navigator.push(context, route);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            '${userWhoPosted.username}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${timeago.format(critique.created)}',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      Spacer(),
                      currentUser.uid == userWhoPosted.uid
                          ? IconButton(
                              tooltip: 'Delete Post',
                              onPressed: () async {
                                final bool confirm =
                                    await locator<ModalService>()
                                        .showConfirmation(
                                            context: context,
                                            title: 'Delete this critique.',
                                            message: 'Are you sure?');

                                if (!confirm) return;

                                await locator<CritiqueService>().deleteCritique(
                                  critiqueID: critique.id,
                                  userID: critique.userID,
                                  created: critique.created,
                                );

                                locator<ModalService>().showAlert(
                                    context: context,
                                    title: 'Critique deleted.',
                                    message:
                                        'Pull and refresh to see results.');
                              },
                              color: Colors.red,
                              icon: Icon(Icons.delete),
                              iconSize: 20,
                            )
                          : SizedBox.shrink(),
                      IconButton(
                        tooltip: 'Report This Post',
                        onPressed: () async {
                          bool confirm = await locator<ModalService>()
                              .showConfirmation(
                                  context: context,
                                  title: 'Report This?',
                                  message:
                                      'If this material was abusive, disrespectful, or uncomfortable, let us know please. This post will become flagged and removed from your timeline on the next page refresh.');

                          if (!confirm) return;

                          await locator<CritiqueService>()
                              .updateCritique(critiqueID: critique.id, data: {
                            'modified': DateTime.now(),
                            'safe': false,
                          });

                          locator<ModalService>().showAlert(
                            context: context,
                            title: 'Reported!',
                            message:
                                'This critique has now been reported. After you refresh the page, you will no longer see that post.',
                          );
                        },
                        color: Colors.red,
                        icon: Icon(Icons.report),
                        iconSize: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
