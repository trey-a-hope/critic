import 'package:critic/blocs/searchMovies/SearchMoviesBloc.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesCache.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesPage.dart';
import 'package:critic/blocs/searchMovies/SearchMoviesRepository.dart';
import 'package:critic/blocs/searchUsers/Bloc.dart' as SEARCH_USERS_BP;
import 'package:critic/pages/SettingsPage.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:critic/blocs/profile/Bloc.dart' as PROFILE_BP;
import 'package:critic/blocs/home/Bloc.dart' as HOME_BP;
import 'package:critic/blocs/editProfile/Bloc.dart' as EDIT_PROFILE_BP;
import 'package:flutter_bloc/flutter_bloc.dart';

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
    //BLoC for Home Page.
    BlocProvider(
      create: (BuildContext context) => HOME_BP.HomeBloc()
        ..add(
          HOME_BP.LoadPageEvent(),
        ),
      child: HOME_BP.HomePage(),
    ),
    //BLoC for Profile Page.
    BlocProvider(
      create: (BuildContext context) => PROFILE_BP.ProfileBloc()
        ..add(
          PROFILE_BP.LoadPageEvent(),
        ),
      child: PROFILE_BP.ProfilePage(),
    ),
    //BLoC for Settings Page.
    SettingsPage(),
  ];
  final List<BottomNavyBarItem> items = [
    BottomNavyBarItem(
      icon: Icon(Icons.home),
      title: Text(
        'Home',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      activeColor: Colors.red,
      textAlign: TextAlign.center,
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.person),
      title: Text(
        'Profile',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      activeColor: Colors.blue,
      textAlign: TextAlign.center,
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.settings),
      title: Text(
        'Settings',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
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
        return AppBar(
          title: Text('Home'),
          leading: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              final SEARCH_USERS_BP.SearchUsersRepository
                  _searchUsersRepository =
                  SEARCH_USERS_BP.SearchUsersRepository(
                cache: SEARCH_USERS_BP.SearchUsersCache(),
              );

              Route route = MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SEARCH_USERS_BP.SearchUsersBloc(
                      searchUsersRepository: _searchUsersRepository)
                    ..add(SEARCH_USERS_BP.LoadPageEvent()),
                  child: SEARCH_USERS_BP.SearchUsersPage(),
                ),
              );

              Navigator.push(context, route);
            },
          ),
          actions: <Widget>[
            IconButton(
              tooltip: 'Movie Search',
              icon: Icon(Icons.movie),
              onPressed: () {
                final SearchMoviesRepository _searchMoviesRepository =
                    SearchMoviesRepository(
                  cache: SearchMoviesCache(),
                );

                Route route = MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SearchMoviesBloc(
                        searchMoviesRepository: _searchMoviesRepository),
                    child: SearchMoviesPage(),
                  ),
                );

                Navigator.push(context, route);
              },
            )
          ],
        );
      case 1:
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
      case 2:
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
