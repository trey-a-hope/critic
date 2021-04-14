import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:critic/blocs/searchUsers/Bloc.dart' as SEARCH_USERS_BP;
import 'package:critic/blocs/searchMovies/Bloc.dart' as SEARCH_MOVIES_BP;
import 'package:critic/main.dart';
import 'package:critic/pages/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:critic/blocs/home/home_bloc.dart' as HOME_BP;
import 'package:critic/blocs/profile/profile_bloc.dart' as PROFILE_BP;
import 'package:critic/blocs/explore/explore_bloc.dart' as EXPLORE_BP;
import 'package:critic/blocs/create_recommendation/create_recommendation_bloc.dart'
    as CREATE_RECOMMENDATION_BP;
import 'package:critic/blocs/edit_profile/edit_profile_bloc.dart'
    as EDIT_PROFILE_BP;
import 'package:critic/blocs/watchlist/Bloc.dart' as WATCHLIST_BP;
import 'package:critic/blocs/recommendations/recommendations_bloc.dart'
    as RECOMMENDATIONS_BP;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class EntryPage extends StatefulWidget {
  final MyAppState myAppState;
  EntryPage({@required this.myAppState});
  @override
  State createState() => EntryPageState(myAppState: myAppState);
}

class EntryPageState extends State<EntryPage> {
  EntryPageState({@required this.myAppState});
  final MyAppState myAppState;

  static GlobalKey homeGlobalKey = GlobalKey();
  static GlobalKey exploreGlobalKey = GlobalKey();
  static GlobalKey watchlistGlobalKey = GlobalKey();
  static GlobalKey recommendationsGlobalKey = GlobalKey();
  static GlobalKey profileGlobalKey = GlobalKey();
  static GlobalKey settingsGlobalKey = GlobalKey();

  int currentIndex = 0;

  void _showTutorial() async {
    await Future.delayed(Duration(microseconds: 100));

    TutorialCoachMark tutorial = TutorialCoachMark(context,
        targets: [
          TargetFocus(
            enableOverlayTab: true,
            identify: 'Target 1',
            keyTarget: homeGlobalKey,
            contents: [
              ContentTarget(
                align: AlignContent.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Home',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Preview the biggest and most talked about films.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          TargetFocus(
            enableOverlayTab: true,
            identify: 'Target 2',
            keyTarget: exploreGlobalKey,
            contents: [
              ContentTarget(
                align: AlignContent.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Explore',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'View the most recent critiques and create your own.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          TargetFocus(
            enableOverlayTab: true,
            identify: 'Target 3',
            keyTarget: watchlistGlobalKey,
            contents: [
              ContentTarget(
                align: AlignContent.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Watchlist',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Save movies here as a reminder to watch later.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          TargetFocus(
            enableOverlayTab: true,
            identify: 'Target 4',
            keyTarget: recommendationsGlobalKey,
            contents: [
              ContentTarget(
                align: AlignContent.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Recommendations',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'See movies that your friends have recommended.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          TargetFocus(
            enableOverlayTab: true,
            identify: 'Target 5',
            keyTarget: profileGlobalKey,
            contents: [
              ContentTarget(
                align: AlignContent.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'View your critiques, followers, and who you follow.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ], // List<TargetFocus>
        colorShadow: Colors.black, onFinish: () {
      print('finish');
    }, onClickTarget: (target) {
      print(target);
    }, onClickSkip: () {
      print('skip');
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool seenTutorial = prefs.getBool('seenTutorial') ?? false;

    if (!seenTutorial) {
      tutorial.show();
      prefs.setBool('seenTutorial', true);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _showTutorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      //Home Page
      BlocProvider(
        create: (BuildContext context) => HOME_BP.HomeBloc()
          ..add(
            HOME_BP.LoadPageEvent(),
          ),
        child: HOME_BP.HomePage(),
      ),
      //Explore Page
      BlocProvider(
        create: (BuildContext context) => EXPLORE_BP.ExploreBloc()
          ..add(
            EXPLORE_BP.LoadPageEvent(),
          ),
        child: EXPLORE_BP.ExplorePage(),
      ),

      //Recommendations Page
      BlocProvider(
        create: (context) => RECOMMENDATIONS_BP.RecommendationsBloc()
          ..add(RECOMMENDATIONS_BP.LoadPageEvent()),
        child: RECOMMENDATIONS_BP.RecommendationsPage(),
      ),
      //Profile Page
      BlocProvider(
        create: (BuildContext context) => PROFILE_BP.ProfileBloc(),
        child: PROFILE_BP.ProfilePage(),
      ),
      //Settings Page
      SettingsView(myAppState: myAppState),
    ];

    return Scaffold(
      appBar: _buildAppBar(index: currentIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Route route = MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SEARCH_MOVIES_BP.SearchMoviesBloc(
                searchMoviesRepository: SEARCH_MOVIES_BP.SearchMoviesRepository(
                  cache: SEARCH_MOVIES_BP.SearchMoviesCache(),
                ),
              ),
              child: SEARCH_MOVIES_BP.SearchMoviesPage(
                returnMovie: false,
              ),
            ),
          );

          Navigator.push(context, route);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: children[currentIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.grey[700],
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        icons: [
          Icons.home,
          Icons.explore,
          Icons.message,
          Icons.person,
        ],
        activeIndex: currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }

  Widget _buildAppBar({@required int index}) {
    switch (index) {
      case 0:
        return AppBar(
          title: Text(
            'Home',
          ),
        );
      case 1:
        return AppBar(
          title: Text(
            'Explore',
          ),
        );
      case 2:
        return AppBar(
          title: Text(
            'Recommendations',
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        CREATE_RECOMMENDATION_BP.CreateRecommendationBloc()
                          ..add(
                            CREATE_RECOMMENDATION_BP.LoadPageEvent(),
                          ),
                    child: CREATE_RECOMMENDATION_BP.CreateRecommendationPage(),
                  ),
                );

                Navigator.push(context, route);
              },
            ),
          ],
        );
      case 3:
        return AppBar(
          title: Text('Profile'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SEARCH_USERS_BP.SearchUsersBloc(
                    searchUsersRepository:
                        SEARCH_USERS_BP.SearchUsersRepository(
                      cache: SEARCH_USERS_BP.SearchUsersCache(),
                    ),
                  )..add(SEARCH_USERS_BP.LoadPageEvent()),
                  child: SEARCH_USERS_BP.SearchUsersPage(
                    returnUser: false,
                  ),
                ),
              );

              Navigator.push(context, route);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.movie),
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => WATCHLIST_BP.WatchlistBloc()
                      ..add(WATCHLIST_BP.LoadPageEvent()),
                    child: WATCHLIST_BP.WatchlistPage(),
                  ),
                );

                Navigator.push(context, route);
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => EDIT_PROFILE_BP.EditProfileBloc()
                      ..add(
                        EDIT_PROFILE_BP.LoadPage(),
                      ),
                    child: EDIT_PROFILE_BP.EditProfileView(),
                  ),
                );

                Navigator.push(context, route);
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (context) => SettingsView(myAppState: myAppState),
                );

                Navigator.push(context, route);
              },
            ),
          ],
        );

      default:
        return null;
        break;
    }
  }
}
