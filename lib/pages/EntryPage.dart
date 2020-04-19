import 'package:critic/pages/CreatePage.dart';
import 'package:critic/pages/HomePage.dart';
import 'package:critic/pages/ProfilePage.dart';
import 'package:critic/pages/SettingsPage.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EntryPage extends StatefulWidget {
  @override
  State createState() => EntryPageState();
}

class EntryPageState extends State<EntryPage> {
  final GetIt getIt = GetIt.I;
  int currentIndex = 0;

  final List<String> childrenTitle = [
    'Home',
    'Create',
    'Profile',
    'Settings',
  ];
  final List<Widget> children = [
    HomePage(),
    CreatePage(),
    ProfilePage(),
    SettingsPage(),
  ];
  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      title: Text('Create'),
    ),
    BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Profile')),
    BottomNavigationBarItem(
        icon: Icon(Icons.settings), title: Text('Settings')),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          childrenTitle[currentIndex],
        ),
        centerTitle: true,
      ),
      body: children[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add),
            title: Text('Create'),
            activeColor: Colors.deepPurple,
            textAlign: TextAlign.center,
          ),
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
        ],
      ),
    );
  }
}
