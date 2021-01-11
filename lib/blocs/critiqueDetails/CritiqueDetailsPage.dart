import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/widgets/SmallCritiqueView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pagination/pagination.dart';
import '../../Constants.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart' as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/postComment/Bloc.dart' as POST_COMMENT_BP;
import 'package:critic/blocs/comments/Bloc.dart' as COMMENTS_BP;
import 'package:critic/blocs/likes/Bloc.dart' as LIKES_BP;
import 'package:critic/blocs/createCritique/Bloc.dart' as CREATE_CRITIQUE_BP;
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

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

  Future<List<CritiqueModel>> fetchSimilarCritiques(int offset) async {
    //Fetch template documents.
    List<DocumentSnapshot> documentSnapshots =
        await locator<CritiqueService>().retrieveSimilarCritiques(
      limit: 25,
      startAfterDocument:
          _critiqueDetailsBloc.similarCritiquesStartAfterDocument,
      uid: _critiqueDetailsBloc.critiqueModel.uid,
      imdbID: _critiqueDetailsBloc.critiqueModel.imdbID,
    );

    //Return an empty list if there are no new documents.
    if (documentSnapshots.isEmpty) {
      return [];
    }

    _critiqueDetailsBloc.similarCritiquesStartAfterDocument =
        documentSnapshots[documentSnapshots.length - 1];

    List<CritiqueModel> critiques = [];

    //Convert documents to template models.
    documentSnapshots.forEach((documentSnapshot) {
      CritiqueModel critiqueModel = CritiqueModel.fromDoc(ds: documentSnapshot);
      critiques.add(critiqueModel);
    });

    //todo: sort critiques client side.

    return critiques;
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
              centerTitle: true,
              title: Text('${critiqueUser.username} says...'),
            ),
            floatingActionButton: SpeedDial(
              backgroundColor: Theme.of(context).buttonColor,
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
              child: ListView(
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    margin: EdgeInsets.only(bottom: 20.0),
                    height: 300,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () async {},
                            child: CachedNetworkImage(
                              imageUrl: '${movie.poster}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(5.0, 5.0),
                                        blurRadius: 10.0)
                                  ],
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SelectableText(
                                  '\"${critique.message}\"',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Spacer(),
                                RaisedButton(
                                    color: Colors.red.shade900,
                                    textColor: Colors.white,
                                    child: Text('View Details'),
                                    onPressed: () async {
                                      final MovieModel movieModel =
                                          await locator<MovieService>()
                                              .getMovieByID(id: movie.imdbID);

                                      Route route = MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) =>
                                              CREATE_CRITIQUE_BP
                                                  .CreateCritiqueBloc(
                                                      movie: movieModel)
                                                ..add(
                                                  CREATE_CRITIQUE_BP
                                                      .LoadPageEvent(),
                                                ),
                                          child: CREATE_CRITIQUE_BP
                                              .CreateCritiquePage(),
                                        ),
                                      );

                                      Navigator.push(context, route);
                                    })
                              ],
                            ),
                            margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Theme.of(context).canvasColor,
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
                  ListTile(
                    leading: InkWell(
                      onTap: () async {
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
                      child: CachedNetworkImage(
                        imageUrl: '${critiqueUser.imgUrl}',
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    title: Text('${critiqueUser.username}',
                        style: Theme.of(context).textTheme.headline4),
                    subtitle: Text(
                        '${timeago.format(critique.created, allowFromNow: true)} on ${DateFormat('MMM dd, yyyy').format(critique.created)}',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Similar Critiques',
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: PaginationList<CritiqueModel>(
                      scrollDirection: Axis.horizontal,
                      onLoading: Spinner(),
                      onPageLoading: Spinner(),
                      separatorWidget: Divider(
                        height: 0,
                        color: Theme.of(context).dividerColor,
                      ),
                      itemBuilder:
                          (BuildContext context, CritiqueModel critique) {
                        return Container(
                          height: 100,
                          color: Colors.grey.shade100,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 100,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text(critique.movieTitle),
                            ),
                          ),
                        );
                      },
                      pageFetch: fetchSimilarCritiques,
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
                      onEmpty: Container(
                        height: 100,
                        width: 200,
                        color: Colors.green,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  // Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FloatingActionButton.extended(
                          backgroundColor: Theme.of(context).buttonColor,
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
