// import 'package:critic/models/MovieModel.dart';
// import 'package:critic/models/MovieSearchResultItem.dart';
// import 'package:critic/pages/MovieDetailsPage.dart';
// import 'package:critic/services/MovieService.dart';
// import 'package:critic/widgets/SideDrawer.dart';
// import 'package:critic/widgets/Spinner.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get_it/get_it.dart';
// import 'package:pagination/pagination.dart';
// import 'package:flappy_search_bar/flappy_search_bar.dart';

// import '../ServiceLocator.dart';

// class SearchResultsPage extends StatefulWidget {
//   const SearchResultsPage({Key key, @required this.searchText})
//       : super(key: key);
//   final String searchText;

//   @override
//   State createState() => SearchResultsPageState(searchText: searchText);
// }

// class SearchResultsPageState extends State<SearchResultsPage> {
//   SearchResultsPageState({@required this.searchText});
//   final String searchText;
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   int page = 1;
//   bool endPageFetch = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   // Future<List<MovieSearchModel>> pageFetch(int offset) async {
//   //   List<MovieSearchModel> movies = await locator<MovieService>()
//   //       .getMovieBySearch(search: searchText, page: page);
//   //   if (movies.isEmpty) endPageFetch = true;

//   //   page = page + 1;

//   //   return movies;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: Text('Results'),
//           centerTitle: true,
//         ),
//         body: null

//         // body: SafeArea(
//         //   child: PaginationList<MovieSearchModel>(
//         //     onLoading: Spinner(),
//         //     onPageLoading: Spinner(),
//         //     separatorWidget: Divider(),
//         //     itemBuilder: (BuildContext context, MovieSearchModel movie) {
//         //       return ListTile(
//         //         leading: CircleAvatar(
//         //           backgroundImage: NetworkImage(movie.poster),
//         //         ),
//         //         title: Text('${movie.title}'),
//         //         subtitle: Text('Year: ${movie.year}'),
//         //         trailing: Icon(Icons.chevron_right),
//         //         onTap: () {
//         //           Navigator.of(context).push(
//         //             MaterialPageRoute(
//         //               builder: (context) => MovieDetailsPage(
//         //                 imdbID: movie.imdbID,
//         //               ),
//         //             ),
//         //           );
//         //         },
//         //       );
//         //     },
//         //     pageFetch: pageFetch,
//         //     onError: (dynamic error) => Center(
//         //       child: Text('Something Went Wrong'),
//         //     ),
//         //     onEmpty: Center(
//         //       child: Text('No results.'),
//         //     ),
//         //   ),
//         // ),
//         );
//   }
// }
