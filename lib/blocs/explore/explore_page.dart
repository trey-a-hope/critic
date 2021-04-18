part of 'explore_bloc.dart';

class ExplorePage extends StatefulWidget {
  @override
  State createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin
    implements ExploreBlocDelegate {
  ExploreBloc _exploreBloc;

  final GlobalKey keyButton = GlobalKey();

  TabController _tabController;

  int _tabControllerIndex = 0;

  int _numberOfTabs = 26;

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

  String _genreLastNAID = '';
  String _genreFamilyLastID = '';
  String _genreMusicLastID = '';
  String _genreMusicalLastID = '';
  String _genreHistoryLastID = '';
  String _genreDocumentaryLastID = '';
  String _genreBiographyLastID = '';
  String _genreFilmNoirLastID = '';
  String _genreShortLastID = '';
  String _genreSportLastID = '';
  String _genreWarLastID = '';
  String _genreWesternLastID = '';
  String _genreTalkShowLastID = '';
  String _genreRealityTVLastID = '';

  void _setGenreLastID({@required String genre, @required String lastID}) {
    switch (genre) {
      case 'Action':
        _genreLastActionID = lastID;
        break;
      case 'Adventure':
        _genreLastAdventureID = lastID;
        break;
      case 'Animation':
        _genreLastAnimationID = lastID;
        break;
      case 'Comedy':
        _genreLastComedyID = lastID;
        break;
      case 'Crime':
        _genreLastCrimeID = lastID;
        break;
      case 'Drama':
        _genreLastDramaID = lastID;
        break;
      case 'Fantasy':
        _genreLastFantasyID = lastID;
        break;
      case 'Horror':
        _genreLastHorrorID = lastID;
        break;
      case 'Mystery':
        _genreLastMysteryID = lastID;
        break;
      case 'Romance':
        _genreLastRomanceID = lastID;
        break;
      case 'Sci-Fi':
        _genreLastSciFiID = lastID;
        break;
      case 'Thriller':
        _genreLastThrillerID = lastID;
        break;
      case 'N/A':
        _genreLastNAID = lastID;
        break;
      case 'Family':
        _genreFamilyLastID = lastID;
        break;
      case 'Music':
        _genreMusicLastID = lastID;
        break;
      case 'Musical':
        _genreMusicalLastID = lastID;
        break;
      case 'History':
        _genreHistoryLastID = lastID;
        break;
      case 'Documentary':
        _genreDocumentaryLastID = lastID;
        break;
      case 'Biography':
        _genreBiographyLastID = lastID;
        break;
      case 'Film-Noir':
        _genreFilmNoirLastID = lastID;
        break;
      case 'Short':
        _genreShortLastID = lastID;
        break;
      case 'Sport':
        _genreSportLastID = lastID;
        break;
      case 'War':
        _genreWarLastID = lastID;
        break;
      case 'Western':
        _genreWesternLastID = lastID;
        break;
      case 'Talk-Show':
        _genreTalkShowLastID = lastID;
        break;
      case 'Reality-TV':
        _genreRealityTVLastID = lastID;
        break;
      default:
        break;
    }
  }

  String _getGenreLastID({@required String genre}) {
    switch (genre) {
      case 'Action':
        return _genreLastActionID;
      case 'Adventure':
        return _genreLastAdventureID;
      case 'Animation':
        return _genreLastAnimationID;
      case 'Comedy':
        return _genreLastComedyID;
      case 'Crime':
        return _genreLastCrimeID;
      case 'Drama':
        return _genreLastDramaID;
      case 'Fantasy':
        return _genreLastFantasyID;
      case 'Horror':
        return _genreLastHorrorID;
      case 'Mystery':
        return _genreLastMysteryID;
      case 'Romance':
        return _genreLastRomanceID;
      case 'Sci-Fi':
        return _genreLastSciFiID;
      case 'Thriller':
        return _genreLastThrillerID;
      case 'N/A':
        return _genreLastNAID;
      case 'Family':
        return _genreFamilyLastID;
      case 'Music':
        return _genreMusicLastID;
      case 'Musical':
        return _genreMusicalLastID;
      case 'History':
        return _genreHistoryLastID;
      case 'Documentary':
        return _genreDocumentaryLastID;
      case 'Biography':
        return _genreBiographyLastID;
      case 'Film-Noir':
        return _genreFilmNoirLastID;
      case 'Short':
        return _genreShortLastID;
      case 'Sport':
        return _genreSportLastID;
      case 'War':
        return _genreWarLastID;
      case 'Western':
        return _genreWesternLastID;
      case 'Talk-Show':
        return _genreTalkShowLastID;
      case 'Reality-TV':
        return _genreRealityTVLastID;
      default:
        return '';
    }
  }

  @override
  void initState() {
    _exploreBloc = BlocProvider.of<ExploreBloc>(context);
    _exploreBloc.setDelegate(delegate: this);

    _tabController = TabController(vsync: this, length: _numberOfTabs);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTab({@required String title, @required IconData iconData}) {
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

          String lastID = _getGenreLastID(genre: genre);

          critiques = [];

          critiques = await locator<CritiqueService>().listByGenre(
            genre: genre,
            limit: PAGE_FETCH_LIMIT,
            lastID: lastID,
          );

          if (critiques.isEmpty) return critiques;

          _setGenreLastID(
              genre: genre, lastID: critiques[critiques.length - 1].id);

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
      onRefresh: () async {
        _resetFilterIDs();

        _exploreBloc.add(
          LoadPageEvent(),
        );

        return;
      },
    );
  }

  void _resetFilterIDs() {
    _genreLastActionID = '';
    _genreLastAdventureID = '';
    _genreLastAnimationID = '';
    _genreLastComedyID = '';
    _genreLastCrimeID = '';
    _genreLastDramaID = '';
    _genreLastFantasyID = '';
    _genreLastHorrorID = '';
    _genreLastMysteryID = '';
    _genreLastRomanceID = '';
    _genreLastSciFiID = '';
    _genreLastThrillerID = '';
    _genreLastNAID = '';
    _genreFamilyLastID = '';
    _genreMusicLastID = '';
    _genreMusicalLastID = '';
    _genreHistoryLastID = '';
    _genreDocumentaryLastID = '';
    _genreBiographyLastID = '';
    _genreFilmNoirLastID = '';
    _genreShortLastID = '';
    _genreSportLastID = '';
    _genreWarLastID = '';
    _genreWesternLastID = '';
    _genreTalkShowLastID = '';
    _genreRealityTVLastID = '';
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
                  print(index);
                },
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Theme.of(context).indicatorColor,
                tabs: [
                  _buildTab(title: 'Action', iconData: MdiIcons.run),
                  _buildTab(title: 'Adventure', iconData: MdiIcons.globeModel),
                  _buildTab(title: 'Animation', iconData: MdiIcons.drawing),
                  _buildTab(title: 'Biography', iconData: MdiIcons.drawing),
                  _buildTab(title: 'Comedy', iconData: MdiIcons.emoticon),
                  _buildTab(title: 'Crime', iconData: MdiIcons.pistol),
                  _buildTab(
                      title: 'Documentary', iconData: MdiIcons.emoticonCry),
                  _buildTab(title: 'Drama', iconData: MdiIcons.emoticonCry),
                  _buildTab(title: 'Family', iconData: MdiIcons.unicorn),
                  _buildTab(title: 'Fantasy', iconData: MdiIcons.unicorn),
                  _buildTab(title: 'Film-Noir', iconData: MdiIcons.unicorn),
                  _buildTab(title: 'History', iconData: MdiIcons.bloodBag),
                  _buildTab(title: 'Horror', iconData: MdiIcons.bloodBag),
                  _buildTab(title: 'Music', iconData: MdiIcons.briefcaseSearch),
                  _buildTab(
                      title: 'Musical', iconData: MdiIcons.briefcaseSearch),
                  _buildTab(
                      title: 'Mystery', iconData: MdiIcons.briefcaseSearch),
                  _buildTab(title: 'N/A', iconData: MdiIcons.briefcaseSearch),
                  _buildTab(title: 'Reality-TV', iconData: MdiIcons.heart),
                  _buildTab(title: 'Romance', iconData: MdiIcons.heart),
                  _buildTab(title: 'Sci-Fi', iconData: MdiIcons.alien),
                  _buildTab(title: 'Short', iconData: MdiIcons.alien),
                  _buildTab(title: 'Sport', iconData: MdiIcons.alien),
                  _buildTab(
                      title: 'Talk-Show', iconData: MdiIcons.emoticonDead),
                  _buildTab(title: 'Thriller', iconData: MdiIcons.emoticonDead),
                  _buildTab(title: 'War', iconData: MdiIcons.emoticonDead),
                  _buildTab(title: 'Western', iconData: MdiIcons.emoticonDead)
                ],
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildList(genre: 'Action', currentUser: currentUser),
                  _buildList(genre: 'Adventure', currentUser: currentUser),
                  _buildList(genre: 'Animation', currentUser: currentUser),
                  _buildList(genre: 'Biography', currentUser: currentUser),
                  _buildList(genre: 'Comedy', currentUser: currentUser),
                  _buildList(genre: 'Crime', currentUser: currentUser),
                  _buildList(genre: 'Documentary', currentUser: currentUser),
                  _buildList(genre: 'Drama', currentUser: currentUser),
                  _buildList(genre: 'Family', currentUser: currentUser),
                  _buildList(genre: 'Fantasy', currentUser: currentUser),
                  _buildList(genre: 'Film-Noir', currentUser: currentUser),
                  _buildList(genre: 'History', currentUser: currentUser),
                  _buildList(genre: 'Horror', currentUser: currentUser),
                  _buildList(genre: 'Music', currentUser: currentUser),
                  _buildList(genre: 'Musical', currentUser: currentUser),
                  _buildList(genre: 'Mystery', currentUser: currentUser),
                  _buildList(genre: 'N/A', currentUser: currentUser),
                  _buildList(genre: 'Reality-TV', currentUser: currentUser),
                  _buildList(genre: 'Romance', currentUser: currentUser),
                  _buildList(genre: 'Sci-Fi', currentUser: currentUser),
                  _buildList(genre: 'Short', currentUser: currentUser),
                  _buildList(genre: 'Sport', currentUser: currentUser),
                  _buildList(genre: 'Talk-Show', currentUser: currentUser),
                  _buildList(genre: 'Thriller', currentUser: currentUser),
                  _buildList(genre: 'War', currentUser: currentUser),
                  _buildList(genre: 'Western', currentUser: currentUser),
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
