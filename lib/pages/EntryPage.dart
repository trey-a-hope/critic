import 'package:critic/Constants.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesBloc.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesCache.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesPage.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesRepository.dart';
import 'package:critic/blocs/searchUsers/Bloc.dart' as SEARCH_USERS_BP;
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
  @override
  State createState() => EntryPageState();
}

class EntryPageState extends State<EntryPage> {
  static GlobalKey exploreGlobalKey = GlobalKey();
  static GlobalKey critiqueGlobalKey = GlobalKey();
  static GlobalKey watchlistGlobalKey = GlobalKey();
  static GlobalKey profileGlobalKey = GlobalKey();
  static GlobalKey settingsGlobalKey = GlobalKey();

  int currentIndex = 0;

  final List<String> childrenTitle = [
    'Explore',
    'Critique',
    'Watchlist',
    'Profile',
    'Settings',
  ];

  final List<Widget> children = [
    //Home Page
    BlocProvider(
      create: (BuildContext context) => EXPLORE_BP.ExploreBloc()
        ..add(
          EXPLORE_BP.LoadPageEvent(),
        ),
      child: EXPLORE_BP.ExplorePage(),
    ),
    //Critique Page
    BlocProvider(
      create: (context) => SearchMoviesBloc(
        searchMoviesRepository: SearchMoviesRepository(
          cache: SearchMoviesCache(),
        ),
      ),
      child: SearchMoviesPage(),
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
    SettingsPage(),
  ];

  final List<BottomNavyBarItem> items = [
    BottomNavyBarItem(
      icon: Icon(
        Icons.explore,
        key: exploreGlobalKey,
      ),
      title: Text(
        'Explore',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      activeColor: COLOR_NAVY,
      textAlign: TextAlign.center,
    ),
    BottomNavyBarItem(
      icon: Icon(
        MdiIcons.movieEdit,
        key: critiqueGlobalKey,
      ),
      title: Text(
        'Critique',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      activeColor: COLOR_NAVY,
      textAlign: TextAlign.center,
    ),
    BottomNavyBarItem(
      icon: Icon(
        MdiIcons.bookmark,
        key: watchlistGlobalKey,
      ),
      title: Text(
        'Watchlist',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      activeColor: COLOR_NAVY,
      textAlign: TextAlign.center,
    ),
    BottomNavyBarItem(
      icon: Icon(
        Icons.person,
        key: profileGlobalKey,
      ),
      title: Text(
        'Profile',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      activeColor: COLOR_NAVY,
      textAlign: TextAlign.center,
    ),
    BottomNavyBarItem(
      icon: Icon(
        Icons.settings,
        key: settingsGlobalKey,
      ),
      title: Text(
        'Settings',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      activeColor: COLOR_NAVY,
      textAlign: TextAlign.center,
    ),
  ];

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
                          "View the most recent critiques from everyone or people you follow.",
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
            identify: "Target 2",
            keyTarget: critiqueGlobalKey,
            contents: [
              ContentTarget(
                align: AlignContent.top,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Search",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Find a movie/tv show that you want to critique.",
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
    _showTutorial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(index: currentIndex),
      body: children[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: items,
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
        );
      case 1:
        return AppBar(
          title: Text(
            'Search',
          ),
        );
      case 2:
        return AppBar(
          title: Text(
            'Watchlist',
          ),
        );
      case 3:
        return AppBar(
          title: Text('Profile'),
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
            )
          ],
        );
      case 4:
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
