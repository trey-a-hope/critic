import 'package:critic/pages/entry_controller.dart';
import 'package:flutter/material.dart';
import 'package:critic/blocs/search_users/search_users_bloc.dart'
    as SEARCH_USERS_BP;
import 'package:critic/blocs/search_movies/search_movies_bloc.dart'
    as SEARCH_MOVIES_BP;
import 'package:critic/pages/settings_view.dart';
import 'package:critic/blocs/home/home_bloc.dart' as HOME_BP;
import 'package:critic/blocs/profile/profile_bloc.dart' as PROFILE_BP;
import 'package:critic/blocs/explore/explore_bloc.dart' as EXPLORE_BP;
import 'package:critic/blocs/create_recommendation/create_recommendation_bloc.dart'
    as CREATE_RECOMMENDATION_BP;
import 'package:critic/blocs/edit_profile/edit_profile_bloc.dart'
    as EDIT_PROFILE_BP;
import 'package:critic/blocs/recommendations/recommendations_bloc.dart'
    as RECOMMENDATIONS_BP;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

class EntryView extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final EntryController entryController = Get.find();

  final List<Widget> viewOptions = [
    //Home Page
    BlocProvider(
      create: (BuildContext context) => HOME_BP.HomeBloc()
        ..add(
          HOME_BP.LoadPageEvent(),
        ),
      child: HOME_BP.HomePage(),
    ),

    /// Search Users page.
    BlocProvider(
      create: (context) => SEARCH_MOVIES_BP.SearchMoviesBloc(
        searchMoviesRepository: SEARCH_MOVIES_BP.SearchMoviesRepository(
          cache: SEARCH_MOVIES_BP.SearchMoviesCache(),
        ),
      ),
      child: SEARCH_MOVIES_BP.SearchMoviesPage(
        returnMovie: false,
      ),
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
    SettingsView(),
  ];

  final List<PreferredSizeWidget> appBarOptions = [
    AppBar(
      title: Text(
        'Home',
      ),
    ),
    AppBar(
      title: Text(
        'Explore',
      ),
    ),
    AppBar(
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

            // Navigator.push(context, route);
          },
        ),
      ],
    ),
    AppBar(
      title: Text('Profile'),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          Route route = MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SEARCH_USERS_BP.SearchUsersBloc(
                searchUsersRepository: SEARCH_USERS_BP.SearchUsersRepository(
                  cache: SEARCH_USERS_BP.SearchUsersCache(),
                ),
              )..add(SEARCH_USERS_BP.LoadPageEvent()),
              child: SEARCH_USERS_BP.SearchUsersPage(
                returnUser: false,
              ),
            ),
          );

          // Navigator.push(context, route);
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
                    EDIT_PROFILE_BP.LoadPage(),
                  ),
                child: EDIT_PROFILE_BP.EditProfileView(),
              ),
            );

            //Navigator.push(context, route);
          },
        ),
      ],
    ),
  ];

  @override
  Widget build(context) {
    final EntryController entryController = Get.put(EntryController());
    final Color bottomNavBarBackgroundColor = Colors.black;

    return Scaffold(
      appBar: appBarOptions[entryController.navBarIndex.value],
      body: Obx(
        () => viewOptions[entryController.navBarIndex.toInt()],
      ),
      bottomNavigationBar: FluidNavBar(
        style: FluidNavBarStyle(
          iconSelectedForegroundColor: Colors.white,
          barBackgroundColor: bottomNavBarBackgroundColor,
          iconBackgroundColor: bottomNavBarBackgroundColor,
          iconUnselectedForegroundColor: Colors.white,
        ),
        icons: [
          FluidNavBarIcon(
            icon: Icons.home,
          ),
          FluidNavBarIcon(
            icon: Icons.add,
          ),
          FluidNavBarIcon(
            icon: Icons.explore,
          ),
          FluidNavBarIcon(
            icon: Icons.list,
          ),
          FluidNavBarIcon(
            icon: Icons.person,
          ),
          FluidNavBarIcon(
            icon: Icons.settings,
          ),
        ],
        onChange: (index) {
          // entryController.increment();
          entryController.setCount(index: index);
        },
      ),
    );
  }
}
