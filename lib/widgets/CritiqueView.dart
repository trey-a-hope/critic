import 'package:critic/ServiceLocator.dart';
import 'package:critic/main.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/widgets/Spinner.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    Future getUserFuture = locator<UserService>().retrieveUser(uid: critique.userID);
    Future getMovieFuture = locator<MovieService>().getMovieByID(id: critique.imdbID);

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

            UserModel user = snapshot.data[0];
            MovieModel movie = snapshot.data[1];
            print(movie.title);

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(movie.poster),
              ),
              title: Text(
                movie.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.red,
                    
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  
                  children: [
                    TextSpan(
                      text: '\n\"${critique.message}\"',
                      
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontSize: 18),
                    ),
                    TextSpan(
                      text: '\n\n${user.username}, ${timeago.format(critique.created)}',
                      style: TextStyle(
                          color: Colors.grey, fontFamily: 'Montserrat'),
                    )
                  ],
                ),
              ),
              trailing: CircleAvatar(
                backgroundImage: NetworkImage(user.imgUrl),
              ),
            );
        }
      },
    );
  }
}
