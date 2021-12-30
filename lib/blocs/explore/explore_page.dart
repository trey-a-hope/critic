part of 'explore_bloc.dart';

class ExplorePage extends StatefulWidget {
  @override
  State createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin
    implements ExploreBlocDelegate {
  final GlobalKey keyButton = GlobalKey();
  final int _numberOfTabs = 26;

  late TabController _tabController;

  int _tabControllerIndex = 0;

  @override
  void initState() {
    context.read<ExploreBloc>().setDelegate(delegate: this);

    _tabController = TabController(vsync: this, length: _numberOfTabs);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (BuildContext context, ExploreState state) {
        if (state is LoadingState) {
          return Spinner();
        }

        if (state is LoadedState) {
          final UserModel currentUser = state.currentUser;

          _tabController.animateTo(_tabControllerIndex);

          return DefaultTabController(
            length: _numberOfTabs,
            child: Scaffold(
              appBar: TabBar(
                onTap: (index) {
                  _tabControllerIndex = index;
                },
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Theme.of(context).indicatorColor,
                tabs: [
                  for (int i = 0; i < genres.length; i++) ...[
                    ExploreTab(
                      title: genres[i].title,
                      iconData: genres[i].iconData,
                    ),
                  ]
                ],
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  for (int i = 0; i < genres.length; i++) ...[
                    ExploreList(
                      genre: genres[i].title,
                      currentUser: currentUser,
                      onRefresh: () {
                        context.read<ExploreBloc>().add(
                              LoadPageEvent(),
                            );
                      },
                    ),
                  ]
                ],
              ),
            ),
          );
        }

        if (state is ErrorState) {
          return Center(
            child: Text('Error: ${state.error.toString()}'),
          );
        }
        return Container();
      },
    );
  }

  @override
  void showMessage({
    required String title,
    required String body,
  }) {
    locator<ModalService>().showAlert(
      context: context,
      title: title,
      message: body,
    );
  }
}
