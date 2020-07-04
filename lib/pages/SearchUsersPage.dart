import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Constants.dart';
import '../ServiceLocator.dart';

class SearchUsersPage extends StatefulWidget {
  @override
  State createState() => SearchUsersPageState();
}

class SearchUsersPageState extends State<SearchUsersPage> {
  //SearchBar searchAppBar;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<AlgoliaObjectSnapshot> results = List<AlgoliaObjectSnapshot>();
  bool searching = false;
  bool isSearchingGems = true;

  @override
  void initState() {
    super.initState();

    // searchAppBar = SearchBar(
    //     inBar: true,
    //     hintText: 'Enter username...',
    //     buildDefaultAppBar: (context) {
    //       return AppBar(
    //         backgroundColor: Colors.black,
    //         automaticallyImplyLeading: true,
    //         title: Text('Search Users'),
    //         actions: [
    //           searchAppBar.getSearchAction(context),
    //         ],
    //       );
    //     },
    //     setState: setState,
    //     onSubmitted: onSubmitted);
  }

  void onSubmitted(String value) {
    if (value == '') return;
    search(value);
  }

  search(String value) async {
    setState(
      () {
        searching = true;
      },
    );

    Algolia algolia = Algolia.init(
      applicationId: ALGOLIA_APP_ID,
      apiKey: ALGOLIA_SEARCH_API_KEY,
    );

    AlgoliaQuery query = algolia.instance.index('Users').search(value);
    // query = query.setFacetFilter('isGem:$_isSearchingGems');

    results = (await query.getObjects()).hits;

    setState(
      () {
        searching = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      //appBar: searchAppBar.build(context),
      // floatingActionButton: _buildFAB(),
      body: searching == true
          ? Spinner()
          : results.length == 0
              ? Center(
                  child: Text("No results found."),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, int index) {
                    AlgoliaObjectSnapshot snap = results[index];
                    UserModel user =
                        UserModel.extractAlgoliaObjectSnapshot(snap);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.imgUrl),
                      ),
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        locator<ModalService>().showAlert(
                            context: context,
                            title: 'To-DO',
                            message: 'Open user profile.');
                      },
                    );
                  },
                ),
    );
  }

  // _buildFAB() {
  //   return FloatingActionButton(
  //     elevation: Theme.of(context).floatingActionButtonTheme.elevation,
  //     backgroundColor: _isSearchingGems ? Colors.green : Colors.white,
  //     child: Icon(MdiIcons.diamondStone,
  //         color: _isSearchingGems ? Colors.white : Colors.green),
  //     onPressed: () {
  //       setState(() {
  //         _isSearchingGems = !_isSearchingGems;
  //         //getIt<Modal>().showInSnackBar(scaffoldKey: _scaffoldKey, message: 'Now searching ${_isSearchingGems ? 'Gems' : 'General Users'}');
  //       });
  //     },
  //   );
  // }
}
