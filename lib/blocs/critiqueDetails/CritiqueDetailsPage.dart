import 'package:critic/Constants.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/MovieView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart' as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/postComment/Bloc.dart' as POST_COMMENT_BP;
import 'package:critic/blocs/comments/Bloc.dart' as COMMENTS_BP;
import 'package:critic/blocs/likes/Bloc.dart' as LIKES_BP;
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;

import 'package:timeago/timeago.dart' as timeago;

class CritiqueDetailsPage extends StatefulWidget {
  @override
  State createState() => CritiqueDetailsPageState();
}

class CritiqueDetailsPageState extends State<CritiqueDetailsPage>
    implements CRITIQUE_DETAILS_BP.CritiqueDetailsBlocDelegate {
  CRITIQUE_DETAILS_BP.CritiqueDetailsBloc _critiqueDetailsBloc;

  @override
  void initState() {
    _critiqueDetailsBloc =
        BlocProvider.of<CRITIQUE_DETAILS_BP.CritiqueDetailsBloc>(context);
    _critiqueDetailsBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CRITIQUE_DETAILS_BP.CritiqueDetailsBloc,
        CRITIQUE_DETAILS_BP.CritiqueDetailsState>(
      builder: (BuildContext context,
          CRITIQUE_DETAILS_BP.CritiqueDetailsState state) {
        if (state is CRITIQUE_DETAILS_BP.LoadingState) {
          return Scaffold(
            appBar: AppBar(),
            body: Spinner(),
          );
        }

        if (state is CRITIQUE_DETAILS_BP.LoadedState) {
          final CritiqueModel critique = state.critiqueModel;
          final MovieModel movie = state.movieModel;
          final UserModel currentUser = state.currentUser;
          final UserModel critiqueUser = state.critiqueUser;
          final bool isLiked = state.isLiked;
          final int likeCount = state.likeCount;

          return Scaffold(
            appBar: AppBar(
              title: Text('${critique.movieTitle}'),
            ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: IconThemeData(size: 22.0),
              curve: Curves.bounceIn,
              children: [
                isLiked
                    ? SpeedDialChild(
                        child: Icon(Icons.favorite, color: Colors.red),
                        backgroundColor: Colors.white,
                        onTap: () {
                          _critiqueDetailsBloc.add(
                            CRITIQUE_DETAILS_BP.UnlikeCritiqueEvent(),
                          );
                        },
                        label: 'Unlike',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        labelBackgroundColor: Colors.white,
                      )
                    : SpeedDialChild(
                        child: Icon(Icons.favorite, color: Colors.white),
                        backgroundColor: Colors.red,
                        onTap: () {
                          _critiqueDetailsBloc.add(
                            CRITIQUE_DETAILS_BP.LikeCritiqueEvent(),
                          );
                        },
                        label: 'Like',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        labelBackgroundColor: Colors.red,
                      ),
                SpeedDialChild(
                  child: Icon(Icons.comment, color: Colors.white),
                  backgroundColor: Colors.blue,
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => POST_COMMENT_BP.PostCommentBloc(
                          critique: critique,
                          critiqueUser: critiqueUser,
                        )..add(
                            POST_COMMENT_BP.LoadPageEvent(),
                          ),
                        child: POST_COMMENT_BP.PostCommentPage(),
                      ),
                    );

                    Navigator.push(context, route);
                  },
                  label: 'Post Comment',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                  labelBackgroundColor: Colors.blue,
                ),
                currentUser.uid == critique.uid
                    ? SpeedDialChild(
                        child: Icon(Icons.delete, color: Colors.white),
                        backgroundColor: Colors.black,
                        onTap: () async {
                          final bool confirm = await locator<ModalService>()
                              .showConfirmation(
                                  context: context,
                                  title: 'Delete Critique',
                                  message: 'Are you sure?');

                          if (!confirm) return;

                          _critiqueDetailsBloc.add(
                            CRITIQUE_DETAILS_BP.DeleteCritiqueEvent(),
                          );
                        },
                        label: 'Delete',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        labelBackgroundColor: Colors.black,
                      )
                    : SpeedDialChild(
                        child: Icon(Icons.report, color: Colors.white),
                        backgroundColor: Colors.black,
                        onTap: () async {
                          bool confirm = await locator<ModalService>()
                              .showConfirmation(
                                  context: context,
                                  title: 'Report Critique',
                                  message:
                                      'If this material was abusive, disrespectful, or uncomfortable, let us know please. This post will become flagged and removed from your timeline.');

                          if (!confirm) return;

                          _critiqueDetailsBloc.add(
                            CRITIQUE_DETAILS_BP.ReportCritiqueEvent(),
                          );
                        },
                        label: 'Report',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        labelBackgroundColor: Colors.black,
                      ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  MovieView(
                    movieModel: movie,
                  ),
                  ListTile(
                    leading: InkWell(
                      onTap: () {
                        if (critiqueUser.uid == currentUser.uid) return;

                        Route route = MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                OTHER_PROFILE_BP.OtherProfileBloc(
                              otherUserID: '${critiqueUser.uid}',
                            )..add(
                                    OTHER_PROFILE_BP.LoadPageEvent(),
                                  ),
                            child: OTHER_PROFILE_BP.OtherProfilePage(),
                          ),
                        );

                        Navigator.push(context, route);
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage('${critiqueUser.imgUrl}'),
                      ),
                    ),
                    title: Text('${critiqueUser.username}'),
                    trailing: Text(
                      '${timeago.format(critique.created, allowFromNow: true)}',
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  Padding(
                    child: Text(
                      '\"${critique.message}\"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: COLOR_NAVY,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    padding: EdgeInsets.all(15),
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FloatingActionButton.extended(
                          backgroundColor: COLOR_NAVY,
                          onPressed: () {
                            Route route = MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => COMMENTS_BP.CommentsBloc(
                                  critique: critique,
                                  currentUser: currentUser,
                                )..add(
                                    COMMENTS_BP.LoadPageEvent(),
                                  ),
                                child: COMMENTS_BP.CommentsPage(),
                              ),
                            );

                            Navigator.push(context, route);
                          },
                          label: Text(
                            'View All Comments',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Route route = MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => LIKES_BP.LikesBloc(
                                    critique: critique,
                                  )..add(
                                      LIKES_BP.LoadPageEvent(),
                                    ),
                                  child: LIKES_BP.LikesPage(),
                                ),
                              );

                              Navigator.push(context, route);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '$likeCount',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }

        if (state is CRITIQUE_DETAILS_BP.ErrorState) {
          return Center(
            child: Text('Error: ${state.error.toString()}'),
          );
        }

        return Container();
      },
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showAlert(context: context, title: '', message: message);
  }
}
