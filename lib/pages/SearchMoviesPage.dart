// import 'package:critic/models/UserModel.dart';
// import 'package:critic/services/ModalService.dart';
// import 'package:critic/widgets/Searchbar.dart';
// import 'package:critic/widgets/Spinner.dart';
// import 'package:flutter/material.dart';
// import 'package:algolia/algolia.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// import '../Constants.dart';
// import '../ServiceLocator.dart';

// class SearchMoviesPage extends StatefulWidget {
//   @override
//   State createState() => SearchMoviesPageState();
// }

// class SearchMoviesPageState extends State<SearchMoviesPage> {
//   SearchBar searchAppBar;
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   // List<AlgoliaObjectSnapshot> results;
//   bool searching = false;
//   // bool isSearchingGems = true;

//   @override
//   void initState() {
//     super.initState();

//     searchAppBar = SearchBar(
//         inBar: true,
//         hintText: 'Enter title of movie / show...',
//         buildDefaultAppBar: (context) {
//           return AppBar(
//             backgroundColor: Colors.black,
//             automaticallyImplyLeading: true,
//             title: Text('Search Movies / Shows'),
//             actions: [
//               searchAppBar.getSearchAction(context),
//             ],
//           );
//         },
//         setState: setState,
//         onSubmitted: onSubmitted);
//   }

//   void onSubmitted(String value) {
//     if (value == '') return;
//     _search(value);
//   }

//   _search(String value) async {
//     setState(
//       () {
//         searching = true;
//       },
//     );

//     // Algolia algolia = Algolia.init(
//     //   applicationId: ALGOLIA_APP_ID,
//     //   apiKey: ALGOLIA_SEARCH_API_KEY,
//     // );

//     // AlgoliaQuery query = algolia.instance.index('Users').search(value);
//     // // query = query.setFacetFilter('isGem:$_isSearchingGems');

//     // results = (await query.getObjects()).hits;

//     setState(
//       () {
//         searching = false;
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: scaffoldKey,
//         appBar: searchAppBar.build(context),
//         // floatingActionButton: _buildFAB(),
//         body: searching == true
//             ? Spinner()
//             : Center(
//                 child: Text('To Do'),
//               ));
//   }

//   // _buildFAB() {
//   //   return FloatingActionButton(
//   //     elevation: Theme.of(context).floatingActionButtonTheme.elevation,
//   //     backgroundColor: _isSearchingGems ? Colors.green : Colors.white,
//   //     child: Icon(MdiIcons.diamondStone,
//   //         color: _isSearchingGems ? Colors.white : Colors.green),
//   //     onPressed: () {
//   //       setState(() {
//   //         _isSearchingGems = !_isSearchingGems;
//   //         //getIt<Modal>().showInSnackBar(scaffoldKey: _scaffoldKey, message: 'Now searching ${_isSearchingGems ? 'Gems' : 'General Users'}');
//   //       });
//   //     },
//   //   );
//   // }
// }
