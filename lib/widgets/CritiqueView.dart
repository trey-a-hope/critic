import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/otherProfile/Bloc.dart';
import 'package:critic/main.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/widgets/Spinner.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'RoundedContainer.dart';

class CritiqueView extends StatefulWidget {
  const CritiqueView({Key key, @required this.critique}) : super(key: key);
  final CritiqueModel critique;
  @override
  State createState() => CritiqueViewState(critique: critique);
}

class CritiqueViewState extends State<CritiqueView> {
  CritiqueViewState({@required this.critique});
  final CritiqueModel critique;

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
            return Spinner();
            break;
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            }

            UserModel userWhoPosted = snapshot.data[0];
            MovieModel movie = snapshot.data[1];
            print(movie.title);

            return buildCritiqueView(
              context: context,
              movie: movie,
              userWhoPosted: userWhoPosted,
            );

          // return ListTile(
          //   leading: CircleAvatar(
          //     backgroundImage: NetworkImage(movie.poster),
          //   ),
          //   title: Text(
          //     movie.title,
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //         color: Colors.red,
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold),
          //   ),
          //   subtitle: RichText(
          //     textAlign: TextAlign.center,
          //     text: TextSpan(
          //       children: [
          //         TextSpan(
          //           text: '\n\"${critique.message}\"',
          //           style: TextStyle(
          //               color: Colors.black,
          //               fontFamily: 'Montserrat',
          //               fontSize: 18),
          //         ),
          //         TextSpan(
          //           text:
          //               '\n\n${user.username}, ${timeago.format(critique.created)}',
          //           style: TextStyle(
          //               color: Colors.grey, fontFamily: 'Montserrat'),
          //         )
          //       ],
          //     ),
          //   ),
          //   trailing: CircleAvatar(
          //     backgroundImage: NetworkImage(user.imgUrl),
          //   ),
          // );
        }
      },
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
      height: 225,
      child: Row(
        children: <Widget>[
          Container(
            width: 130,
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
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                          userWhoPosted.imgUrl,
                        ),
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
                          Text('${timeago.format(critique.created)}', style: TextStyle(fontSize: 12),)
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        tooltip: 'Report This Post',
                        onPressed: () async {
                          bool confirm = await locator<ModalService>()
                              .showConfirmation(
                                  context: context,
                                  title: 'Report This ',
                                  message: '');

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
                      IconButton(
                        tooltip: '${userWhoPosted.username}',
                        onPressed: () async {
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
                        color: Colors.purple,
                        icon: Icon(Icons.chevron_right),
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
