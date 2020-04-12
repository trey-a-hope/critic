import 'package:critic/Constants.dart';
import 'package:critic/pages/FindMoviePage.dart';
import 'package:critic/pages/HomePage.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
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
  final Color iconColor = Colors.black;

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
              if (page != 'Home') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              }
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.movie, color: iconColor),
          //   title: Text('My Critiques'),
          //   onTap: () {
          //     if (page != 'My Critiques') {
          //       Navigator.of(context).pushReplacement(
          //         MaterialPageRoute(
          //           builder: (context) => FindMoviePage(),
          //         ),
          //       );
          //     }
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.movie, color: iconColor),
            title: Text('Find Movie'),
            onTap: () {
              if (page != 'Find Movie') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FindMoviePage(),
                  ),
                );
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person, color: iconColor),
            title: Text('Profile'),
            onTap: () {
              if (page != 'Profile') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FindMoviePage(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: iconColor),
            title: Text('Settings'),
            onTap: () {
              if (page != 'Settings') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FindMoviePage(),
                  ),
                );
              }
            },
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: iconColor),
            title: Text('Logout'),
            onTap: () async {
              bool confirm = await getIt<IModalService>().showConfirmation(
                  context: context, title: 'Logout', message: 'Are you sure?');
              if (confirm) {
                //Clear stack of routes.
                while(Navigator.of(context).canPop()){
                  Navigator.pop(context);
                }
                //Sign the user out and update the onAuth stream.
                await getIt<IAuthService>().signOut();
                print('Goodbye...');
              }
            },
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'v. $version',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
