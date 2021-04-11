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
  String _genreLastComedyID = '';
  String _genreLastDramaID = '';
  String _genreLastRomanceID = '';
  String _genreLastSciFiID = '';

  final int _pageFetchLimit = 25;

  @override
  void initState() {
    _exploreBloc = BlocProvider.of<ExploreBloc>(context);
    _exploreBloc.setDelegate(delegate: this);
    super.initState();
  }

  // Future<List<CritiqueModel>> pageFetch(int offset) async {
  //   //Fetch template documents.
  //   List<DocumentSnapshot> documentSnapshots =
  //       await locator<CritiqueService>().retrieveAllCritiquesFromFirebase(
  //     limit: _exploreBloc.limit,
  //     startAfterDocument: _exploreBloc.startAfterDocument,
  //   );

  //   //Return an empty list if there are no new documents.
  //   if (documentSnapshots.isEmpty) {
  //     return [];
  //   }

  //   _exploreBloc.startAfterDocument =
  //       documentSnapshots[documentSnapshots.length - 1];

  //   List<CritiqueModel> critiques = [];

  //   //Convert documents to template models.
  //   documentSnapshots.forEach((documentSnapshot) {
  //     CritiqueModel critiqueModel = CritiqueModel.fromDoc(ds: documentSnapshot);
  //     critiques.add(critiqueModel);
  //   });

  //   return critiques;
  // }
  //
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
      child: PaginationList<NewCritiqueModel>(
        onLoading: Spinner(),
        onPageLoading: Spinner(),
        separatorWidget: Divider(
          height: 0,
          color: Theme.of(context).dividerColor,
        ),
        itemBuilder: (BuildContext context, NewCritiqueModel critique) {
          return NewCritiqueView(
            critique: critique,
            currentUser: currentUser,
          );
        },
        pageFetch: (int offset) async {
          List<NewCritiqueModel> critiques;
          switch (genre) {
            case 'Action':
              critiques = await locator<NewCritiqueService>().listByGenre(
                genre: 'Action',
                limit: 25,
                lastID: _genreLastActionID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastActionID = critiques[0].id;

              break;
            case 'Comedy':
              critiques = await locator<NewCritiqueService>().listByGenre(
                genre: 'Comedy',
                limit: 25,
                lastID: _genreLastComedyID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastComedyID = critiques[0].id;

              break;
            case 'Drama':
              critiques = await locator<NewCritiqueService>().listByGenre(
                genre: 'Drama',
                limit: 25,
                lastID: _genreLastDramaID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastDramaID = critiques[0].id;

              break;
            case 'Sci-Fi':
              critiques = await locator<NewCritiqueService>().listByGenre(
                genre: 'Sci-Fi',
                limit: 25,
                lastID: _genreLastSciFiID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastSciFiID = critiques[0].id;

              break;
            case 'Romance':
              critiques = await locator<NewCritiqueService>().listByGenre(
                genre: 'Romance',
                limit: 25,
                lastID: _genreLastRomanceID,
              );

              if (critiques.isEmpty) return critiques;

              _genreLastRomanceID = critiques[0].id;

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
            length: 5,
            child: Scaffold(
              appBar: TabBar(
                isScrollable: true,
                indicatorColor: Theme.of(context).indicatorColor,
                tabs: [
                  _buildTap(title: 'Action', iconData: MdiIcons.run),
                  _buildTap(title: 'Comedy', iconData: MdiIcons.emoticon),
                  _buildTap(title: 'Drama', iconData: MdiIcons.emoticonCry),
                  _buildTap(title: 'Romance', iconData: MdiIcons.heart),
                  _buildTap(title: 'Sci-Fi', iconData: MdiIcons.alien)
                ],
              ),
              body: TabBarView(
                children: [
                  _buildList(genre: 'Action', currentUser: currentUser),
                  _buildList(genre: 'Comedy', currentUser: currentUser),
                  _buildList(genre: 'Drama', currentUser: currentUser),
                  _buildList(genre: 'Romance', currentUser: currentUser),
                  _buildList(genre: 'Sci-Fi', currentUser: currentUser),
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
