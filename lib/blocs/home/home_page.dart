part of 'home_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void _checkForAppUpdate(BuildContext context) async {
    final NewVersion newVersion = NewVersion();
    newVersion.showAlertIfNecessary(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        if (state is HomeLoadingState) {
          _checkForAppUpdate(context);
          return Spinner();
        }

        if (state is HomeLoadedState) {
          final UserModel currentUser = state.currentUser;
          final List<UserModel> mostRecentUsers = state.mostRecentUsers;
          // final List<MovieModel> popularMovies = state.popularMovies;
          final List<CritiqueModel> mostRecentCritiques =
              state.mostRecentCritiques;
          // final int critiqueCount = state.critiqueCount;
          final int userCount = state.userCount;

          return ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      height: 290,
                      // color: Colors.deepOrange,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3), BlendMode.darken),
                          image: AssetImage('assets/images/theater.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      )),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      Image.asset(ASSET_APP_ICON, scale: 10),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                        'Critic'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                      ),
                      Text(
                        'What are you watching?',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        padding: EdgeInsets.all(10),
                        child: Card(
                          color: Theme.of(context).canvasColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 15, bottom: 5),
                                    child: Text('Movies',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: Text('7m',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5)),
                                ],
                              ),
                              // Column(
                              //   children: <Widget>[
                              //     Container(
                              //         padding:
                              //             EdgeInsets.only(top: 15, bottom: 5),
                              //         child: Text('Critiques',
                              //             style: Theme.of(context)
                              //                 .textTheme
                              //                 .headline5)),
                              //     Container(
                              //         padding: EdgeInsets.only(bottom: 15),
                              //         child: Text('$critiqueCount',
                              //             style: Theme.of(context)
                              //                 .textTheme
                              //                 .headline5)),
                              //   ],
                              // ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 5),
                                    child: Text('Users',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text('$userCount',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      // Padding(
                      //   padding: EdgeInsets.all(20),
                      //   child: Text(
                      //     'Popular Movies',
                      //     style: Theme.of(context).textTheme.headline3,
                      //   ),
                      // ),
                      // Column(
                      //   children: popularMovies
                      //       .map(
                      //         (movie) => MovieWidget(movie: movie),
                      //       )
                      //       .toList(),
                      // ),
                      // Divider(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Recent Users',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      Container(
                        height: 127,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: mostRecentUsers.length,
                          itemBuilder: (context, index) {
                            final UserModel mostRecentUser =
                                mostRecentUsers[index];

                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (mostRecentUser.uid == currentUser.uid)
                                        return;

                                      Route route = MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) => OTHER_PROFILE_BP
                                              .OtherProfileBloc(
                                            otherUserID:
                                                '${mostRecentUser.uid}',
                                          )..add(
                                              OTHER_PROFILE_BP.LoadPageEvent(),
                                            ),
                                          child: OTHER_PROFILE_BP
                                              .OtherProfilePage(),
                                        ),
                                      );

                                      Navigator.push(context, route);
                                    },
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          Image.network(mostRecentUser.imgUrl)
                                              .image,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    mostRecentUser.username,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  Text(
                                    'Joined ${timeago.format(mostRecentUser.created!, allowFromNow: true)}',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Recent Critiques',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mostRecentCritiques.length,
                          itemBuilder: (context, index) {
                            CritiqueModel otherCritique =
                                mostRecentCritiques[index];
                            return Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: SmallCritiqueView(
                                  critique: otherCritique,
                                  currentUser: currentUser,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        }

        if (state is ErrorState) {
          return Container(
            child: Center(
              child: Text(
                state.error.toString(),
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}
