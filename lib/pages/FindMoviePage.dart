import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/SearchQueryModel.dart';
import 'package:critic/services/MovieService.dart';
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
  String searchQuery = 'The';
  final SearchBarController<SearchQueryModel> searchBarController =
      SearchBarController();
  bool isReplay = false;

  @override
  void initState() {
    super.initState();
  }

  Future<List<SearchQueryModel>> pageFetch(String title) async {
    try {
      List<SearchQueryModel> movies = await getIt<IMovieService>()
          .getMovieBySearch(search: title, page: page);
      return movies;
    } catch (e) {
      throw Error();
    }
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
        child: SearchBar<SearchQueryModel>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: pageFetch,
          searchBarController: searchBarController,
          loader: Spinner(),
          onError: (error) {
            return Center(
              child: Text("Error occurred : ${error.toString()}"),
            );
          },
          emptyWidget: Center(
            child: Text("No results..."),
          ),
          placeHolder: Center(
            child: Icon(
              Icons.search,
              color: Colors.grey[300],
              size: 100,
            ),
          ),
          cancellationWidget: Text("Cancel"),
          // indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),
          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text(
                  'Sort by Title',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  searchBarController
                      .sortList((SearchQueryModel a, SearchQueryModel b) {
                    return a.title.compareTo(b.title);
                  });
                },
              ),
              RaisedButton(
                child: Text(
                  'Sort by Year',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  searchBarController
                      .sortList((SearchQueryModel a, SearchQueryModel b) {
                    return a.year.compareTo(b.year);
                  });
                  // searchBarController.removeSort();
                },
              ),
              RaisedButton(
                child: Text(
                  'Redo',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  isReplay = !isReplay;
                  searchBarController.replayLastSearch();
                },
              ),
            ],
          ),
          onCancelled: () {
            print("Cancelled triggered");
          },
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 1,
          onItemFound: (SearchQueryModel post, int index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(post.poster),
              ),
              title: Text('${post.title}'),
              subtitle: Text('Year: ${post.year}'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            );
          },
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.black,
    //     title: Text('Find Movie'),
    //     centerTitle: true,
    //   ),
    //   drawer: SideDrawer(
    //     page: 'Find Movie',
    //   ),
    //   body: PaginationList<SearchQueryModel>(
    //     onLoading: Spinner(),
    //     onPageLoading: Spinner(),
    //     separatorWidget: Divider(),
    //     itemBuilder: (BuildContext context, SearchQueryModel movie) {
    //       return ListTile(
    //         leading: CircleAvatar(
    //           backgroundImage: NetworkImage(movie.poster),
    //         ),
    //         title: Text('${movie.title}'),
    //         subtitle: Text('Year: ${movie.year}'),
    //         trailing: Icon(Icons.chevron_right),
    //         onTap: () {},
    //       );
    //     },
    //     pageFetch: pageFetch,
    //     onError: (dynamic error) => Center(
    //       child: Text('Something Went Wrong'),
    //     ),
    //     onEmpty: Center(
    //       child: Text('Empty List'),
    //     ),
    //   ),
    // );
  }
}
