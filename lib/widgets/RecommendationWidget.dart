import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/createCritique/Bloc.dart' as CREATE_CRITIQUE_BP;
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'package:critic/models/RecommendationModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendationWidget extends StatefulWidget {
  const RecommendationWidget({
    Key key,
    @required this.recommendation,
    @required this.delete,
  }) : super(key: key);

  final RecommendationModel recommendation;
  final Function delete;

  @override
  State createState() => _RecommendationWidgetState();
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  int _critiqueMessageCharCount = 75;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ExpansionCard(
        leading: InkWell(
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => OTHER_PROFILE_BP.OtherProfileBloc(
                  otherUserID: '${widget.recommendation.senderUID}',
                )..add(
                    OTHER_PROFILE_BP.LoadPageEvent(),
                  ),
                child: OTHER_PROFILE_BP.OtherProfilePage(),
              ),
            );

            Navigator.push(context, route);
          },
          child: CachedNetworkImage(
            imageUrl: '${widget.recommendation.sender.imgUrl}',
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
            '${widget.recommendation.movie.poster}',
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
                '${widget.recommendation.movie.title}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                  '${widget.recommendation.sender.username}, ${timeago.format(widget.recommendation.created, allowFromNow: true)}',
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              '"${widget.recommendation.message}\"',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.movie),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Go To Movie'),
                    ],
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) =>
                            CREATE_CRITIQUE_BP.CreateCritiqueBloc(
                          movie: widget.recommendation.movie,
                        )..add(
                                CREATE_CRITIQUE_BP.LoadPageEvent(),
                              ),
                        child: CREATE_CRITIQUE_BP.CreateCritiquePage(),
                      ),
                    );

                    Navigator.push(context, route);
                  },
                  color: Theme.of(context).buttonColor,
                  textColor: Colors.white,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Delete')
                  ]),
                  onPressed: () async {
                    final bool confirm = await locator<ModalService>()
                        .showConfirmation(
                            context: context,
                            title: 'Delete Recommendation',
                            message: 'Are you sure?');

                    if (!confirm) return;
                    widget.delete();
                  },
                  color: Theme.of(context).buttonColor,
                  textColor: Colors.white,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
