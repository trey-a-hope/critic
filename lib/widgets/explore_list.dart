import 'package:critic/models/critique_model.dart';
import 'package:critic/models/user_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pagination_view/pagination_view.dart';
import '../constants.dart';
import '../service_locator.dart';
import 'Spinner.dart';
import 'critique_view.dart';

class ExploreList extends StatelessWidget {
  final UserModel currentUser;
  final String genre;
  final VoidCallback onRefresh;

  String lastID = '';

  ExploreList({
    Key? key,
    required this.currentUser,
    required this.genre,
    required this.onRefresh,
  }) : super(key: key);

  Future<List<CritiqueModel>> pageFetch(int offset) async {
    List<CritiqueModel> critiques;

    critiques = [];

    critiques = await locator<CritiqueService>().listByGenre(
      genre: genre,
      limit: PAGE_FETCH_LIMIT,
      lastID: lastID,
    );

    if (critiques.isEmpty) return critiques;

    lastID = critiques[critiques.length - 1].id!;

    return critiques;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: PaginationView<CritiqueModel>(
        initialLoader: Spinner(),
        bottomLoader: Spinner(),
        itemBuilder:
            (BuildContext context, CritiqueModel critique, int index) =>
                CritiqueView(
          critique: critique,
          currentUser: currentUser,
        ),
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
      onRefresh: () async {
        lastID = '';
        onRefresh();
        return;
      },
    );
  }
}
