import 'package:critic/Constants.dart';
import 'package:critic/blocs/searchUsers/Bloc.dart' as SEARCH_USERS_BP;
import 'package:critic/blocs/searchMovies/Bloc.dart' as SEARCH_MOVIES_BP;
import 'package:critic/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:critic/pages/SettingsPage.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:critic/blocs/profile/Bloc.dart' as PROFILE_BP;
import 'package:critic/blocs/explore/Bloc.dart' as EXPLORE_BP;
import 'package:critic/blocs/editProfile/Bloc.dart' as EDIT_PROFILE_BP;
import 'package:critic/blocs/watchlist/Bloc.dart' as WATCHLIST_BP;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EntryPage extends StatefulWidget {
  final MyAppState myAppState;
  EntryPage({@required this.myAppState});
  @override
  State createState() => EntryPageState(myAppState: myAppState);
}

class EntryPageState extends State<EntryPage> {
  EntryPageState({@required this.myAppState});
  final MyAppState myAppState;

  static GlobalKey exploreGlobalKey = GlobalKey();
  static GlobalKey watchlistGlobalKey = GlobalKey();
  static GlobalKey profileGlobalKey = GlobalKey();
  static GlobalKey settingsGlobalKey = GlobalKey();

  int currentIndex = 0;

  void _showTutorial() async {
    await Future.delayed(Duration(microseconds: 100));

    TutorialCoachMark tutorial = TutorialCoachMark(context,
        targets: [
          TargetFocus(
            enableOverlayTab: true,
            identify: "Target 1",
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
                        "Explore",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "View the most recent critiques and create your own.",
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
            identify: "Target 3",
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
                        "Watchlist",
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
            identify: "Target 4",
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
                        "Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "View your critiques, followers, and who you follow.",
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
            identify: "Target 5",
            keyTarget: settingsGlobalKey,
            contents: [
              ContentTarget(
                align: AlignContent.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Settings",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Handle settings for the app. Enjoy!",
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
      print("finish");
    }, onClickTarget: (target) {
      print(target);
    }, onClickSkip: () {
      print("skip");
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
      //Explore Page
      BlocProvider(
        create: (BuildContext context) => EXPLORE_BP.ExploreBloc()
          ..add(
            EXPLORE_BP.LoadPageEvent(),
          ),
        child: EXPLORE_BP.ExplorePage(),
      ),
      //Watchlist Page
      BlocProvider(
        create: (context) =>
            WATCHLIST_BP.WatchlistBloc()..add(WATCHLIST_BP.LoadPageEvent()),
        child: WATCHLIST_BP.WatchlistPage(),
      ),
      //Profile Page
      BlocProvider(
        create: (BuildContext context) => PROFILE_BP.ProfileBloc()
          ..add(
            PROFILE_BP.LoadPageEvent(),
          ),
        child: PROFILE_BP.ProfilePage(),
      ),
      //Settings Page
      SettingsPage(myAppState: myAppState),
    ];

    return Scaffold(
      appBar: buildAppBar(index: currentIndex),
      body: children[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(
              Icons.explore,
              key: exploreGlobalKey,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'Explore',
              style: Theme.of(context).textTheme.headline6,
            ),
            activeColor: Theme.of(context).iconTheme.color,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(
              MdiIcons.bookmark,
              key: watchlistGlobalKey,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'Watchlist',
              style: Theme.of(context).textTheme.headline6,
            ),
            activeColor: Theme.of(context).iconTheme.color,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.person,
              key: profileGlobalKey,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.headline6,
            ),
            activeColor: Theme.of(context).iconTheme.color,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.settings,
              key: settingsGlobalKey,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
            activeColor: Theme.of(context).iconTheme.color,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildAppBar({@required int index}) {
    switch (index) {
      case 0:
        return AppBar(
          title: Text(
            'Explore',
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SEARCH_MOVIES_BP.SearchMoviesBloc(
                      searchMoviesRepository:
                          SEARCH_MOVIES_BP.SearchMoviesRepository(
                        cache: SEARCH_MOVIES_BP.SearchMoviesCache(),
                      ),
                    ),
                    child: SEARCH_MOVIES_BP.SearchMoviesPage(),
                  ),
                );

                Navigator.push(context, route);
              },
            )
          ],
        );
      case 1:
        return AppBar(
          title: Text(
            'Watchlist',
          ),
        );
      case 2:
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
                  child: SEARCH_USERS_BP.SearchUsersPage(),
                ),
              );

              Navigator.push(context, route);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => EDIT_PROFILE_BP.EditProfileBloc()
                      ..add(
                        EDIT_PROFILE_BP.LoadPageEvent(),
                      ),
                    child: EDIT_PROFILE_BP.EditProfilePage(),
                  ),
                );

                Navigator.push(context, route);
              },
            ),
          ],
        );
      case 3:
        return AppBar(
          title: Text(
            'Settings',
          ),
        );
      default:
        return null;
        break;
    }
  }
}
