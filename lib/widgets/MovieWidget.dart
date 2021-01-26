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
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/createCritique/Bloc.dart' as CREATE_CRITIQUE_BP;

class MovieWidget extends StatefulWidget {
  const MovieWidget({
    Key key,
    @required this.movie,
  }) : super(key: key);

  final MovieModel movie;

  @override
  State createState() => _MovieWidgetState(
        movie: movie,
      );
}

class _MovieWidgetState extends State<MovieWidget> {
  _MovieWidgetState({
    @required this.movie,
  });

  final MovieModel movie;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text('${movie.title}'),
      ),
    );
  }
}

// Widget movieView() {
//   return InkWell(
//     onTap: () {
//       //TODO: Open movie details.

//       // Route route = MaterialPageRoute(
//       //   builder: (context) => BlocProvider(
//       //     create: (context) => CRITIQUE_DETAILS_BP.CritiqueDetailsBloc(
//       //       critiqueModel: critique,
//       //     )..add(
//       //         CRITIQUE_DETAILS_BP.LoadPageEvent(),
//       //       ),
//       //     child: CRITIQUE_DETAILS_BP.CritiqueDetailsPage(),
//       //   ),
//       // );

//       // Navigator.push(context, route);
//     },
//     child: Container(
//       padding: EdgeInsets.only(left: 10.0, right: 10.0),
//       margin: EdgeInsets.only(bottom: 20.0),
//       height: 300,
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: NetworkImage('${critique.moviePoster}'),
//                     fit: BoxFit.cover),
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.grey,
//                       offset: Offset(5.0, 5.0),
//                       blurRadius: 10.0)
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     '${critique.movieTitle}',
//                     style:
//                         TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
//                   ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   Text("\"${critique.message}\"",
//                       style: TextStyle(
//                           color: Colors.grey.shade900, fontSize: 12.0)),
//                   Spacer(),
//                   Row(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           if (userWhoPosted.uid == currentUser.uid) return;

//                           Route route = MaterialPageRoute(
//                             builder: (context) => BlocProvider(
//                               create: (context) =>
//                                   OTHER_PROFILE_BP.OtherProfileBloc(
//                                 otherUserID: '${userWhoPosted.uid}',
//                               )..add(
//                                       OTHER_PROFILE_BP.LoadPageEvent(),
//                                     ),
//                               child: OTHER_PROFILE_BP.OtherProfilePage(),
//                             ),
//                           );

//                           Navigator.push(context, route);
//                         },
//                         child: CircleAvatar(
//                           backgroundImage: NetworkImage(
//                             '${userWhoPosted.imgUrl}',
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       Column(
//                         children: [
//                           Text(
//                             '${userWhoPosted.username}',
//                             style: TextStyle(
//                               fontSize: 12.0,
//                               color: Colors.black,
//                               height: 1.5,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             '${timeago.format(critique.created, allowFromNow: true)}',
//                             style: TextStyle(
//                               fontSize: 12.0,
//                               color: Colors.grey,
//                               height: 1.5,
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//               margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   bottomRight: Radius.circular(10.0),
//                   topRight: Radius.circular(10.0),
//                 ),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.grey,
//                       offset: Offset(5.0, 5.0),
//                       blurRadius: 10.0)
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }
