import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/critiqueDetails/Bloc.dart' as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
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
      title: Text(
        '\"${critique.message}\"',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      subtitle: Text(
        '${critique.movieTitle} - ${userWhoPosted.username}, ${timeago.format(critique.created, allowFromNow: true)}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
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
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            '${userWhoPosted.imgUrl}',
          ),
        ),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          '${critique.moviePoster}',
        ),
      ),
    );
    // InkWell(
    //   onTap: () {
    //     Route route = MaterialPageRoute(
    //       builder: (context) => BlocProvider(
    //         create: (context) => CRITIQUE_DETAILS_BP.CritiqueDetailsBloc(
    //           critiqueModel: critique,
    //         )..add(
    //             CRITIQUE_DETAILS_BP.LoadPageEvent(),
    //           ),
    //         child: CRITIQUE_DETAILS_BP.CritiqueDetailsPage(),
    //       ),
    //     );

    //     Navigator.push(context, route);
    //   },
    //   child: Container(
    //     padding: EdgeInsets.only(left: 10.0, right: 10.0),
    //     margin: EdgeInsets.only(bottom: 20.0),
    //     height: 300,
    //     child: Row(
    //       children: <Widget>[
    //         Expanded(
    //           child: Container(
    //             decoration: BoxDecoration(
    //               image: DecorationImage(
    //                   image: NetworkImage('${critique.moviePoster}'),
    //                   fit: BoxFit.cover),
    //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //               boxShadow: [
    //                 BoxShadow(
    //                     color: Colors.grey,
    //                     offset: Offset(5.0, 5.0),
    //                     blurRadius: 10.0)
    //               ],
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: Container(
    //             padding: EdgeInsets.all(10.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Text(
    //                   '${critique.movieTitle}',
    //                   style: TextStyle(
    //                       fontSize: 22.0, fontWeight: FontWeight.w700),
    //                 ),
    //                 SizedBox(
    //                   height: 10.0,
    //                 ),
    //                 Text("\"${critique.message}\"",
    //                     style: TextStyle(
    //                         color: Colors.grey.shade900, fontSize: 12.0)),
    //                 Spacer(),
    //                 Row(
    //                   children: [
    //                     InkWell(
    //                       onTap: () {
    //                         if (userWhoPosted.uid == currentUser.uid) return;

    //                         Route route = MaterialPageRoute(
    //                           builder: (context) => BlocProvider(
    //                             create: (context) =>
    //                                 OTHER_PROFILE_BP.OtherProfileBloc(
    //                               otherUserID: '${userWhoPosted.uid}',
    //                             )..add(
    //                                     OTHER_PROFILE_BP.LoadPageEvent(),
    //                                   ),
    //                             child: OTHER_PROFILE_BP.OtherProfilePage(),
    //                           ),
    //                         );

    //                         Navigator.push(context, route);
    //                       },
    //                       child: CircleAvatar(
    //                         backgroundImage: NetworkImage(
    //                           '${userWhoPosted.imgUrl}',
    //                         ),
    //                       ),
    //                     ),
    //                     Spacer(),
    //                     Column(
    //                       children: [
    //                         Text(
    //                           '${userWhoPosted.username}',
    //                           style: TextStyle(
    //                             fontSize: 12.0,
    //                             color: Colors.black,
    //                             height: 1.5,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                         Text(
    //                           '${timeago.format(critique.created, allowFromNow: true)}',
    //                           style: TextStyle(
    //                             fontSize: 12.0,
    //                             color: Colors.grey,
    //                             height: 1.5,
    //                           ),
    //                         ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.only(
    //                 bottomRight: Radius.circular(10.0),
    //                 topRight: Radius.circular(10.0),
    //               ),
    //               color: Colors.white,
    //               boxShadow: [
    //                 BoxShadow(
    //                     color: Colors.grey,
    //                     offset: Offset(5.0, 5.0),
    //                     blurRadius: 10.0)
    //               ],
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
