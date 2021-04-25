import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/Constants.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/blocs/critique_details/critique_details_bloc.dart'
    as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/other_profile/other_profile_bloc.dart'
    as OTHER_PROFILE_BP;
import 'package:critic/models/critique_model.dart';
import 'package:critic/models/user_Model.dart';
import 'package:critic/services/user_service.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class CritiqueView extends StatefulWidget {
  const CritiqueView({
    Key key,
    @required this.critique,
    @required this.currentUser,
  }) : super(key: key);

  final CritiqueModel critique;
  final UserModel currentUser;

  @override
  State createState() => _CritiqueViewState();
}

class _CritiqueViewState extends State<CritiqueView> {
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
    return Padding(
      padding: EdgeInsets.all(10),
      child: ExpansionCard(
        leading: InkWell(
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
        borderRadius: 20,
        background: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),
            BlendMode.darken,
          ),
          child: Image.network(
            '${widget.critique.movie.poster}',
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
          ),
        ),
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${widget.critique.movie.title}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                  '${userWhoPosted.username}, ${timeago.format(widget.critique.created, allowFromNow: true)}',
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
                  Theme.of(context).buttonColor),
              foregroundColor: MaterialStateProperty.all<Color>(
                Colors.white,
              ),
            ),
            child: Text('Read Full Review'),
            onPressed: () {
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
          )
        ],
      ),
    );
  }
}
