import 'package:critic/pages/CreatePage.dart';
import 'package:critic/pages/EditProfilePage.dart';
import 'package:critic/pages/HomePage.dart';
import 'package:critic/pages/ProfilePage.dart';
import 'package:critic/pages/SearchMoviesPage.dart';
import 'package:critic/pages/SearchResultsPage.dart';
import 'package:critic/pages/SearchUsersPage.dart';
import 'package:critic/pages/SettingsPage.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:critic/widgets/AppBarLayout.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EntryPage extends StatefulWidget {
  @override
  State createState() => EntryPageState();
}

class EntryPageState extends State<EntryPage> {
  int currentIndex = 0;

  final List<String> childrenTitle = [
    'Home',
    'Profile',
    'Settings',
  ];

  final List<Widget> children = [
    HomePage(),
    //CreatePage(),
    ProfilePage(),
    SettingsPage(),
  ];
  final List<BottomNavyBarItem> items = [
    BottomNavyBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
      activeColor: Colors.red,
      textAlign: TextAlign.center,
    ),
    // BottomNavyBarItem(
    //   icon: Icon(Icons.add),
    //   title: Text('Create'),
    //   activeColor: Colors.deepPurple,
    //   textAlign: TextAlign.center,
    // ),
    BottomNavyBarItem(
      icon: Icon(Icons.person),
      title: Text(
        'Profile',
      ),
      activeColor: Colors.blue,
      textAlign: TextAlign.center,
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.settings),
      title: Text('Settings'),
      activeColor: Colors.green,
      textAlign: TextAlign.center,
    ),
  ];

  @override
  void initState() {
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
        return AppBarLayout(
          appBarTitle: 'Home',
          leading: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchUsersPage(),
                ),
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchMoviesPage(),
                  ),
                );
              },
            )
          ],
        );
      case 1:
        return AppBarLayout(
          appBarTitle: 'Profile',
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(),
                  ),
                );
              },
            )
          ],
        );
      case 2:
        return AppBarLayout(
          appBarTitle: 'Settings',
        );
      default:
        break;
    }
  }
}
