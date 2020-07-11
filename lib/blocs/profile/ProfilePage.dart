import 'package:critic/blocs/followers/Bloc.dart' as FOLLOWERS_BP;
import 'package:critic/blocs/followings/Bloc.dart' as FOLLOWINGS_BP;

import 'package:critic/blocs/profile/Bloc.dart' as PROFILE_BP;
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/widgets/CritiqueView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final String _timeFormat = 'MMM d, yyyy @ h:mm a';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PROFILE_BP.ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _profileBloc = BlocProvider.of<PROFILE_BP.ProfileBloc>(context);

    return BlocBuilder<PROFILE_BP.ProfileBloc, PROFILE_BP.ProfileState>(
      builder: (BuildContext context, PROFILE_BP.ProfileState state) {
        if (state is PROFILE_BP.LoadingState) {
          return Spinner();
        }

        if (state is PROFILE_BP.LoadedState) {
          return Stack(
            children: <Widget>[
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1535016120720-40c646be5580?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80'),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 25.0, 16.0, 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(16.0),
                              margin: EdgeInsets.only(top: 20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 110.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          state.currentUser.username,
                                          style:
                                              Theme.of(context).textTheme.title,
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text(state.currentUser.email),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Critiques',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('${state.critiques.length}')
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Route route = MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                create: (context) =>
                                                    FOLLOWERS_BP.FollowersBloc(
                                                        followersIDs:
                                                            state.followers)
                                                      ..add(
                                                        FOLLOWERS_BP
                                                            .LoadPageEvent(),
                                                      ),
                                                child: FOLLOWERS_BP
                                                    .FollowersPage(),
                                              ),
                                            );

                                            Navigator.push(context, route);
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                'Followers',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text('${state.followers.length}')
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Route route = MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                create: (context) =>
                                                    FOLLOWINGS_BP
                                                        .FollowingsBloc(
                                                            followingsIDs: state
                                                                .followings)
                                                      ..add(
                                                        FOLLOWINGS_BP
                                                            .LoadPageEvent(),
                                                      ),
                                                child: FOLLOWINGS_BP
                                                    .FollowingsPage(),
                                              ),
                                            );

                                            Navigator.push(context, route);
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                'Following',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text('${state.followings.length}')
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2.0, color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image:
                                        Image.network(state.currentUser.imgUrl)
                                            .image,
                                    fit: BoxFit.cover),
                              ),
                              margin: EdgeInsets.only(left: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                  Expanded(
                    child: state.critiques.isEmpty
                        ? Center(
                            child:
                                Text('You have no critiques at the moment...'),
                          )
                        : ListView.builder(
                            addAutomaticKeepAlives: true,
                            itemCount: state.critiques.length,
                            itemBuilder: (BuildContext context, int index) {
                              CritiqueModel critique = state.critiques[index];
                              return CritiqueView(
                                currentUser: state.currentUser,
                                critique: critique,
                              );
                            },
                          ),
                  )
                ],
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
