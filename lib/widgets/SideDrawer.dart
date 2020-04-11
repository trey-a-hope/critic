import 'package:critic/pages/FindMoviePage.dart';
import 'package:critic/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({Key key, @required this.page}) : super(key: key);

  final String page;

  @override
  State createState() => SideDrawerState(page: page);
}

class SideDrawerState extends State<SideDrawer> {
  SideDrawerState({@required this.page});

  final String page;
  final Color iconColor = Colors.purple;

  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Hello there!'),
                ),
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(
                      'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg'),
                  backgroundColor: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: iconColor),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.movie, color: iconColor),
            title: Text('Find Movie'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => FindMoviePage(),
                ),
              );
            },
          ),
          Spacer(),
          // SafeArea(
          //   child: Padding(
          //     padding: EdgeInsets.only(bottom: 20),
          //     child: Text(
          //       'Version - $version+$buildNumber',
          //       style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 18, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
