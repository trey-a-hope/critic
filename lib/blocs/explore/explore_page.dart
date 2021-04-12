part of 'explore_bloc.dart';

class ExplorePage extends StatefulWidget {
  @override
  State createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage>
    implements ExploreBlocDelegate {
  ExploreBloc _exploreBloc;

  final GlobalKey keyButton = GlobalKey();

  String _genreLastActionID = '';
  String _genreLastAdventureID = '';
  String _genreLastAnimationID = '';
  String _genreLastComedyID = '';
  String _genreLastCrimeID = '';
  String _genreLastDramaID = '';
  String _genreLastFantasyID = '';
  String _genreLastHorrorID = '';
  String _genreLastMysteryID = '';
  String _genreLastRomanceID = '';
  String _genreLastSciFiID = '';
  String _genreLastThrillerID = '';

  @override
  void initState() {
    _exploreBloc = BlocProvider.of<ExploreBloc>(context);
    _exploreBloc.setDelegate(delegate: this);
    super.initState();
  }

  Widget _buildTap({@required String title, @required IconData iconData}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: Theme.of(context).iconTheme.color,
          ),
          SizedBox(
            width: 10,
          ),
          Text(title, style: Theme.of(context).textTheme.headline6),
        ],
      ),
    );
  }

  Widget _buildList({
    @required String genre,
    @required UserModel currentUser,
  }) {
    return RefreshIndicator(
      child: PaginationList<CritiqueModel>(
        onLoading: Spinner(),
        onPageLoading: Spinner(),
        separatorWidget: Divider(
          height: 0,
          color: Theme.of(context).dividerColor,
        ),
        itemBuilder: (BuildContext context, CritiqueModel critique) {
          return CritiqueView(
            critique: critique,
            currentUser: currentUser,
          );
        },
        pageFetch: (int offset) async {
          List<CritiqueModel> critiques;
          switch (genre) {
            case 'Action':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastActionID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastActionID = critiques[0].id;

              break;
            case 'Adventure':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastAdventureID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastAdventureID = critiques[0].id;

              break;
            case 'Animation':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastAnimationID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastAnimationID = critiques[0].id;

              break;
            case 'Comedy':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastComedyID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastComedyID = critiques[0].id;

              break;
            case 'Crime':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastCrimeID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastCrimeID = critiques[0].id;

              break;
            case 'Drama':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastDramaID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastDramaID = critiques[0].id;

              break;
            case 'Fantasy':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastFantasyID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastFantasyID = critiques[0].id;

              break;
            case 'Horror':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastHorrorID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastHorrorID = critiques[0].id;

              break;
            case 'Mystery':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastMysteryID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastMysteryID = critiques[0].id;

              break;
            case 'Romance':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastRomanceID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastRomanceID = critiques[0].id;

              break;
            case 'Sci-Fi':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastSciFiID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastSciFiID = critiques[0].id;

              break;
            case 'Thriller':
              critiques = await locator<CritiqueService>().listByGenre(
                genre: genre,
                limit: PAGE_FETCH_LIMIT,
                lastID: _genreLastThrillerID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastThrillerID = critiques[0].id;

              break;
            default:
              critiques = [];
              break;
          }

          return critiques;
        },
        onError: (dynamic error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 100,
                color: Colors.grey,
              ),
              Text(
                'Error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        onEmpty: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.movieEdit,
                size: 100,
                color: Colors.grey,
              ),
              Text(
                '$MESSAGE_EMPTY_CRITIQUES',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      onRefresh: () {
        _exploreBloc.add(
          LoadPageEvent(),
        );

        return;
      },
    );
  }

  @override
  void dispose() {
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

          return DefaultTabController(
            length: 12,
            child: Scaffold(
              appBar: TabBar(
                isScrollable: true,
                indicatorColor: Theme.of(context).indicatorColor,
                tabs: [
                  _buildTap(title: 'Action', iconData: MdiIcons.run),
                  _buildTap(title: 'Adventure', iconData: MdiIcons.globeModel),
                  _buildTap(title: 'Animation', iconData: MdiIcons.drawing),
                  _buildTap(title: 'Comedy', iconData: MdiIcons.emoticon),
                  _buildTap(title: 'Crime', iconData: MdiIcons.pistol),
                  _buildTap(title: 'Drama', iconData: MdiIcons.emoticonCry),
                  _buildTap(title: 'Fantasy', iconData: MdiIcons.unicorn),
                  _buildTap(title: 'Horror', iconData: MdiIcons.bloodBag),
                  _buildTap(
                      title: 'Mystery', iconData: MdiIcons.briefcaseSearch),
                  _buildTap(title: 'Romance', iconData: MdiIcons.heart),
                  _buildTap(title: 'Sci-Fi', iconData: MdiIcons.alien),
                  _buildTap(title: 'Thriller', iconData: MdiIcons.emoticonDead)
                ],
              ),
              body: TabBarView(
                children: [
                  _buildList(genre: 'Action', currentUser: currentUser),
                  _buildList(genre: 'Adventure', currentUser: currentUser),
                  _buildList(genre: 'Animation', currentUser: currentUser),
                  _buildList(genre: 'Comedy', currentUser: currentUser),
                  _buildList(genre: 'Crime', currentUser: currentUser),
                  _buildList(genre: 'Drama', currentUser: currentUser),
                  _buildList(genre: 'Fantasy', currentUser: currentUser),
                  _buildList(genre: 'Horror', currentUser: currentUser),
                  _buildList(genre: 'Mystery', currentUser: currentUser),
                  _buildList(genre: 'Romance', currentUser: currentUser),
                  _buildList(genre: 'Sci-Fi', currentUser: currentUser),
                  _buildList(genre: 'Thriller', currentUser: currentUser),
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
    @required String title,
    @required String body,
  }) {
    locator<ModalService>().showAlert(
      context: context,
      title: title,
      message: body,
    );
  }
}
