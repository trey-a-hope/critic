import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/SearchQueryModel.dart';
import 'package:critic/pages/MovieDetailsPage.dart';
import 'package:critic/pages/SearchResultsPage.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/widgets/GoodButton.dart';
import 'package:critic/widgets/SideDrawer.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pagination/pagination.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class FindMoviePage extends StatefulWidget {
  @override
  State createState() => FindMoviePageState();
}

class FindMoviePageState extends State<FindMoviePage> {
  final GetIt getIt = GetIt.I;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int page = 1;
  bool endPageFetch = false;
  String searchText = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Find Movie'),
        centerTitle: true,
      ),
      drawer: SideDrawer(
        page: 'Find Movie',
      ),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: TextFormField(
              onChanged: (newSearchText) {
                setState(() {
                  searchText = newSearchText;
                });
              },
              controller: searchController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              maxLengthEnforced: true,
              decoration:
                  InputDecoration(hintText: 'Enter name of movie or show...'),
            ),
          ),
          Spacer(),
          GoodButton(
            title: 'Search',
            onTap: () {
              if (searchText.length < 1) {
                print('Cannot have empty search text.');
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchResultsPage(
                      searchText: searchText,
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }
}
