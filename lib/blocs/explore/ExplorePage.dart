import 'package:critic/blocs/explore/Bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/SmallCritiqueView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants.dart';
import '../../ServiceLocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pagination/pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExplorePage extends StatefulWidget {
  @override
  State createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage>
    implements ExploreBlocDelegate {
  ExploreBloc _exploreBloc;

  final GlobalKey keyButton = GlobalKey();

  @override
  void initState() {
    _exploreBloc = BlocProvider.of<ExploreBloc>(context);
    _exploreBloc.setDelegate(delegate: this);
    super.initState();
  }

  Future<List<CritiqueModel>> pageFetch(int offset) async {
    //Fetch template documents.
    List<DocumentSnapshot> documentSnapshots =
        await locator<CritiqueService>().retrieveAllCritiquesFromFirebase(
      limit: _exploreBloc.limit,
      startAfterDocument: _exploreBloc.startAfterDocument,
    );

    //Return an empty list if there are no new documents.
    if (documentSnapshots.isEmpty) {
      return [];
    }

    _exploreBloc.startAfterDocument =
        documentSnapshots[documentSnapshots.length - 1];

    List<CritiqueModel> critiques = [];

    //Convert documents to template models.
    documentSnapshots.forEach((documentSnapshot) {
      CritiqueModel critiqueModel = CritiqueModel.fromDoc(ds: documentSnapshot);
      critiques.add(critiqueModel);
    });

    return critiques;
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
          final int pageFetchLimit = state.pageFetchLimit;

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: TabBar(
                indicatorColor: Theme.of(context).indicatorColor,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Everyone',
                            style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_people,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Following',
                            style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                  ),
                ],
              ),
              body: TabBarView(
                children: [
                  // Everyone
                  RefreshIndicator(
                    child: PaginationList<CritiqueModel>(
                      onLoading: Spinner(),
                      onPageLoading: Spinner(),
                      separatorWidget: Divider(
                        height: 0,
                        color: Theme.of(context).dividerColor,
                      ),
                      itemBuilder:
                          (BuildContext context, CritiqueModel critique) {
                        return SmallCritiqueView(
                          critique: critique,
                          currentUser: currentUser,
                        );
                      },
                      pageFetch: pageFetch,
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
                  ),
                  // Following
                  RefreshIndicator(
                    child: PaginationList<CritiqueModel>(
                      onLoading: Spinner(),
                      onPageLoading: Spinner(),
                      separatorWidget: Divider(
                        height: 0,
                        color: Theme.of(context).dividerColor,
                      ),
                      itemBuilder:
                          (BuildContext context, CritiqueModel critique) {
                        return SmallCritiqueView(
                          critique: critique,
                          currentUser: currentUser,
                        );
                      },
                      pageFetch: (int offset) async {
                        //Fetch template documents.
                        List<CritiqueModel> critiques =
                            await locator<CritiqueService>()
                                .retrieveCritiquesFromStream(
                          limit: pageFetchLimit,
                          offset: offset,
                          uid: currentUser.uid,
                        );

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
                              'No critiques at this moment.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Create your own or follow someone.')
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
                  )
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
