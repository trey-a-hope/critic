import 'package:critic/Constants.dart';
import 'package:critic/models/CommentModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import '../../ServiceLocator.dart';
import 'Bloc.dart' as COMMENTS_BP;
import 'package:pagination/pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsPage extends StatefulWidget {
  @override
  State createState() => CommentsPageState();
}

class CommentsPageState extends State<CommentsPage>
    implements COMMENTS_BP.CommentsBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  COMMENTS_BP.CommentsBloc _commentsBloc;

  @override
  void initState() {
    _commentsBloc = BlocProvider.of<COMMENTS_BP.CommentsBloc>(context);
    _commentsBloc.setDelegate(delegate: this);
    super.initState();
  }

  Future<List<CommentModel>> pageFetch(int offset) async {
    //Fetch template documents.
    List<DocumentSnapshot> documentSnapshots =
        await locator<CritiqueService>().retrieveCommentsFromFirebase(
      critiqueID: _commentsBloc.critique.id,
      limit: _commentsBloc.limit,
      startAfterDocument: _commentsBloc.startAfterDocument,
    );

    //Return an empty list if there are no new documents.
    if (documentSnapshots.isEmpty) {
      return List<CommentModel>();
    }

    _commentsBloc.startAfterDocument =
        documentSnapshots[documentSnapshots.length - 1];

    List<CommentModel> comments = List<CommentModel>();

    //Convert documents to template models.

    for (var i = 0; i < documentSnapshots.length; i++) {
      DocumentSnapshot documentSnapshot = documentSnapshots[i];
      CommentModel comment = CommentModel.fromDoc(ds: documentSnapshot);

      final UserModel commentUser =
          await locator<UserService>().retrieveUser(uid: comment.uid);

      comment.user = commentUser;

      comments.add(comment);
    }

    return comments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: COLOR_NAVY,
        title: Text(
          'Comments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<COMMENTS_BP.CommentsBloc, COMMENTS_BP.CommentsState>(
        builder: (context, state) {
          if (state is COMMENTS_BP.LoadingState) {
            return Spinner();
          }

          if (state is COMMENTS_BP.LoadedState) {
            final UserModel currentUser = state.currentUser;

            return PaginationList<CommentModel>(
              onLoading: Spinner(),
              onPageLoading: Spinner(),
              separatorWidget: Divider(),
              itemBuilder: (BuildContext context, CommentModel comment) {
                return ListTile(
                  leading: InkWell(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(comment.user.imgUrl),
                    ),
                    onTap: () {
                      Route route = MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              OTHER_PROFILE_BP.OtherProfileBloc(
                            otherUserID: comment.uid,
                          )..add(
                                  OTHER_PROFILE_BP.LoadPageEvent(),
                                ),
                          child: OTHER_PROFILE_BP.OtherProfilePage(),
                        ),
                      );

                      Navigator.push(context, route);
                    },
                  ),
                  subtitle: Text(
                      '${comment.user.username}, ${timeago.format(comment.created, allowFromNow: true)}'),
                  title: Text('\"${comment.message}\"'),
                  trailing: currentUser.uid == comment.uid
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Delete Comment',
                                    message: 'Are you sure?');

                            if (!confirm) return;

                            _commentsBloc.add(
                              COMMENTS_BP.DeleteCommentEvent(
                                commentID: comment.id,
                              ),
                            );
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.report),
                          onPressed: () async {
                            bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Report Comment',
                                    message: 'If this material was abusive, disrespectful, or uncomfortable, let us know please. This comment will become flagged and removed from your timeline.');

                            if (!confirm) return;

                            _commentsBloc.add(
                              COMMENTS_BP.ReportCommentEvent(
                                commentID: comment.id,
                              ),
                            );
                          },
                        ),
                );
              },
              pageFetch: pageFetch,
              onError: (dynamic error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 100,
                      color: Colors.grey,
                    ),
                    Text(
                      'Error',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              onEmpty: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.supervised_user_circle,
                      size: 100,
                      color: Colors.grey,
                    ),
                    Text(
                      'No comments at the moment.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Come back later.')
                  ],
                ),
              ),
            );
          }

          return Center(
            child: Text('You should NEVER see this.'),
          );
        },
      ),
    );
  }

  @override
  void showMessage({@required String message}) {
    locator<ModalService>().showInSnackBar(
      scaffoldKey: _scaffoldKey,
      message: message,
    );
  }
}
