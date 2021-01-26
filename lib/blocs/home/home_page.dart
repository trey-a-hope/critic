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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        if (state is HomeLoadingState) {
          return Spinner();
        }

        if (state is HomeLoadedState) {
          final UserModel currentUser = state.currentUser;
          final List<UserModel> mostRecentUsers = state.mostRecentUsers;

          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: [
              Text(
                'Popular Movies',
                style: Theme.of(context).textTheme.headline3,
              ),
              Divider(),
              Text(
                'Most Recent Users',
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(
                height: 127,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: mostRecentUsers.length,
                  itemBuilder: (context, index) {
                    final UserModel mostRecentUser = mostRecentUsers[index];

                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (mostRecentUser.uid == currentUser.uid) return;

                              Route route = MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) =>
                                      OTHER_PROFILE_BP.OtherProfileBloc(
                                    otherUserID: '${mostRecentUser.uid}',
                                  )..add(
                                          OTHER_PROFILE_BP.LoadPageEvent(),
                                        ),
                                  child: OTHER_PROFILE_BP.OtherProfilePage(),
                                ),
                              );

                              Navigator.push(context, route);
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  Image.network(mostRecentUser.imgUrl).image,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            mostRecentUser.username,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(
                            'Joined ${timeago.format(mostRecentUser.created, allowFromNow: true)}',
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }

        return Container();
      },
    );
  }
}
