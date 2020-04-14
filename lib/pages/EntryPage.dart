import 'package:critic/pages/CreatePage.dart';
import 'package:critic/pages/HomePage.dart';
import 'package:critic/pages/ProfilePage.dart';
import 'package:critic/pages/SettingsPage.dart';
import 'package:critic/widgets/SideDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EntryPage extends StatefulWidget {
  @override
  State createState() => EntryPageState();
}

class EntryPageState extends State<EntryPage> {
  final GetIt getIt = GetIt.I;
  int currentTab = 0;

  final List<String> childrenTitle = [
    // 'Home',
    'Create',
    'Profile',
    'Settings',
  ];
  final List<Widget> children = [
    // HomePage(),
    CreatePage(),
    ProfilePage(),
    SettingsPage(),
  ];
  final List<BottomNavigationBarItem> items = [
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.home),
    //   title: Text('Home'),
    // ),
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
          childrenTitle[currentTab],
        ),
        centerTitle: true,
      ),
      // drawer: SideDrawer(
      //   page: 'Home',
      // ),
      body: children[currentTab],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (tab) {
          setState(() {
            currentTab = tab;
          });
        }, // new
        currentIndex: currentTab, // new
        items: items,
      ),
    );
  }
}
