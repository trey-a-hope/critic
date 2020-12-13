import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/SmallCritiqueView.dart';
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
      return [];
    }

    _otherProfileBloc.startAfterDocument =
        documentSnapshots[documentSnapshots.length - 1];

    List<CritiqueModel> critiques = [];

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
          final bool isFollowing = state.isFollowing;
          final int followerCount = state.followerCount;
          final int followingCount = state.followingCount;

          return Scaffold(
            key: _scaffoldKey,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: colorNavy,
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
                                        '$followerCount Followers',
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
                                        '$followingCount Following',
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
                                isFollowing
                                    ? Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: FullWidthButton(
                                            buttonColor: Colors.white,
                                            text: 'Unfollow Me',
                                            textColor: Colors.red,
                                            onPressed: () {
                                              _otherProfileBloc.add(
                                                OTHER_PROFILE_BP
                                                    .UnfollowEvent(),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: FullWidthButton(
                                            buttonColor: Colors.red,
                                            text: 'Follow Me',
                                            textColor: Colors.white,
                                            onPressed: () {
                                              _otherProfileBloc.add(
                                                OTHER_PROFILE_BP.FollowEvent(),
                                              );
                                            },
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
                                      onPressed: () async {
                                        final bool confirm = await locator<
                                                ModalService>()
                                            .showConfirmation(
                                                context: context,
                                                title:
                                                    'Block ${otherUser.username}?',
                                                message: 'Are you sure?');

                                        if (!confirm) return;

                                        _otherProfileBloc.add(
                                          OTHER_PROFILE_BP.BlockUserEvent(),
                                        );
                                      },
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
                    return SmallCritiqueView(
                      critique: critique,
                      currentUser: otherUser,
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
        }

        return Container();
      },
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }

  @override
  void navigateHome() {
    Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );
  }
}
