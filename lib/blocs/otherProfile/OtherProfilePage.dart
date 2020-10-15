import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/CritiqueView.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pagination/pagination.dart';
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'package:critic/blocs/followers/Bloc.dart' as FOLLOWERS_BP;
import 'package:critic/blocs/followings/Bloc.dart' as FOLLOWINGS_BP;

class OtherProfilePage extends StatefulWidget {
  @override
  State createState() => OtherProfilePageState();
}

class OtherProfilePageState extends State<OtherProfilePage>
    implements OTHER_PROFILE_BP.OtherProfileBlocDelegate {
  final String _timeFormat = 'MMM d, yyyy @ h:mm a';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OTHER_PROFILE_BP.OtherProfileBloc _otherProfileBloc;

  @override
  void initState() {
    _otherProfileBloc =
        BlocProvider.of<OTHER_PROFILE_BP.OtherProfileBloc>(context);
    _otherProfileBloc.setDelegate(delegate: this);
    super.initState();
  }

  Future<List<CritiqueModel>> pageFetch(int offset) async {
    //Fetch template documents.
    List<DocumentSnapshot> documentSnapshots =
        await locator<CritiqueService>().retrieveCritiquesFromFirebase(
      uid: _otherProfileBloc.otherUser.uid,
      limit: _otherProfileBloc.limit,
      startAfterDocument: _otherProfileBloc.startAfterDocument,
    );

    //Return an empty list if there are no new documents.
    if (documentSnapshots.isEmpty) {
      return List<CritiqueModel>();
    }

    _otherProfileBloc.startAfterDocument =
        documentSnapshots[documentSnapshots.length - 1];

    List<CritiqueModel> critiques = List<CritiqueModel>();

    //Convert documents to template models.
    documentSnapshots.forEach((documentSnapshot) {
      CritiqueModel critiqueModel = CritiqueModel.fromDoc(ds: documentSnapshot);
      critiques.add(critiqueModel);
    });

    return critiques;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OTHER_PROFILE_BP.OtherProfileBloc,
        OTHER_PROFILE_BP.OtherProfileState>(
      builder:
          (BuildContext context, OTHER_PROFILE_BP.OtherProfileState state) {
        if (state is OTHER_PROFILE_BP.LoadingState) {
          return Scaffold(
            body: Spinner(),
          );
        }

        if (state is OTHER_PROFILE_BP.LoadedState) {
          final UserModel otherUser = state.otherUser;
          return Scaffold(
            key: _scaffoldKey,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: COLOR_NAVY,
                    expandedHeight: 300.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        '${otherUser.username}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                            image: AssetImage('assets/images/theater.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage('${otherUser.imgUrl}'),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      '${otherUser.critiqueCount} Critiques',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: InkWell(
                                      child: Text(
                                        '? Followers',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Route route = MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) =>
                                                FOLLOWERS_BP.FollowersBloc(
                                              user: otherUser,
                                            )..add(
                                                    FOLLOWERS_BP
                                                        .LoadPageEvent(),
                                                  ),
                                            child: FOLLOWERS_BP.FollowersPage(),
                                          ),
                                        );

                                        Navigator.push(context, route);
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: InkWell(
                                      child: Text(
                                        '? Following',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Route route = MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) =>
                                                FOLLOWINGS_BP.FollowingsBloc(
                                              user: otherUser,
                                            )..add(
                                                    FOLLOWINGS_BP
                                                        .LoadPageEvent(),
                                                  ),
                                            child:
                                                FOLLOWINGS_BP.FollowingsPage(),
                                          ),
                                        );

                                        Navigator.push(context, route);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: FullWidthButton(
                                      buttonColor: Colors.red,
                                      text: 'Follow Me',
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: FullWidthButton(
                                      buttonColor: Colors.red,
                                      text: 'Block Me',
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                child: PaginationList<CritiqueModel>(
                  onLoading: Spinner(),
                  onPageLoading: Spinner(),
                  separatorWidget: Divider(),
                  itemBuilder: (BuildContext context, CritiqueModel critique) {
                    return Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CritiqueView(
                        critique: critique,
                        currentUser: otherUser,
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
                          MdiIcons.movieEdit,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          'No critiques at this moment.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Come back later!')
                      ],
                    ),
                  ),
                ),
                onRefresh: () {
                  _otherProfileBloc.add(
                    OTHER_PROFILE_BP.LoadPageEvent(),
                  );

                  return;
                },
              ),
            ),
          );
          // return Stack(
          //   children: <Widget>[
          //     Container(
          //       height: 250,
          //       width: double.infinity,
          //       decoration: BoxDecoration(
          //         image: DecorationImage(
          //           fit: BoxFit.fill,
          //           image: NetworkImage(
          //               'https://images.unsplash.com/photo-1535016120720-40c646be5580?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80'),
          //         ),
          //       ),
          //     ),
          //     Container(
          //       margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(5.0),
          //       ),
          //       child: Column(
          //         children: <Widget>[
          //           SizedBox(
          //             height: 20,
          //           ),
          //           Stack(
          //             children: <Widget>[
          //               Container(
          //                 padding: EdgeInsets.all(16.0),
          //                 margin: EdgeInsets.only(top: 20.0),
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(5.0),
          //                 ),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: <Widget>[
          //                     Container(
          //                       margin: EdgeInsets.only(left: 110.0),
          //                       child: Column(
          //                         crossAxisAlignment:
          //                             CrossAxisAlignment.start,
          //                         children: <Widget>[
          //                           Text(
          //                             state.otherUser.username,
          //                             style: Theme.of(context)
          //                                 .textTheme
          //                                 .headline6,
          //                           ),
          //                           ListTile(
          //                             contentPadding: EdgeInsets.all(0),
          //                             title: Text(state.otherUser.email),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                     SizedBox(height: 10.0),
          //                     Row(
          //                       children: <Widget>[
          //                         Expanded(
          //                           child: Column(
          //                             children: <Widget>[
          //                               Text(
          //                                 DateFormat(_timeFormat).format(
          //                                     state.otherUser.created),
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               Text('Joined')
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Container(
          //                 height: 100,
          //                 width: 100,
          //                 decoration: BoxDecoration(
          //                   border:
          //                       Border.all(width: 2.0, color: Colors.black),
          //                   borderRadius: BorderRadius.circular(10.0),
          //                   image: DecorationImage(
          //                       image: Image.network(state.otherUser.imgUrl)
          //                           .image,
          //                       fit: BoxFit.cover),
          //                 ),
          //                 margin: EdgeInsets.only(left: 16.0),
          //               ),
          //             ],
          //           ),
          //           SizedBox(height: 20.0),
          //         ],
          //       ),
          //     ),
          //     Align(
          //       alignment: Alignment.bottomCenter,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: <Widget>[
          //           state.isFollowing
          //               ? RaisedButton(
          //                   color: Colors.white,
          //                   textColor: Colors.red,
          //                   child: Text(
          //                     'Unfollow Me',
          //                     style: TextStyle(fontWeight: FontWeight.bold),
          //                   ),
          //                   onPressed: () {
          //                     _otherProfileBloc.add(
          //                       UnfollowEvent(),
          //                     );
          //                   },
          //                 )
          //               : RaisedButton(
          //                   color: Colors.red,
          //                   textColor: Colors.white,
          //                   child: Text(
          //                     'Follow Me',
          //                     style: TextStyle(fontWeight: FontWeight.bold),
          //                   ),
          //                   onPressed: () {
          //                     _otherProfileBloc.add(
          //                       FollowEvent(),
          //                     );
          //                   },
          //                 ),
          //           RaisedButton(
          //             color: Colors.blue.shade900,
          //             textColor: Colors.white,
          //             child: Text(
          //               'Block Me',
          //               style: TextStyle(fontWeight: FontWeight.bold),
          //             ),
          //             onPressed: () async {
          //               final bool confirm = await locator<ModalService>()
          //                   .showConfirmation(
          //                       context: context,
          //                       title: 'Block ${state.otherUser.username}?',
          //                       message: 'Are you sure?');

          //               if (!confirm) return;

          //               _otherProfileBloc.add(
          //                 BlockUserEvent(),
          //               );
          //             },
          //           )
          //         ],
          //       ),
          //     )
          //   ],
          // );
        }

        return Container();
      },
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>().showInSnackBar(
      scaffoldKey: _scaffoldKey,
      message: message,
    );
  }

  @override
  void navigateHome() {
    Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );
  }
}
