import 'package:critic/pages/SearchResultsPage.dart';
import 'package:critic/services/ModalService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ServiceLocator.dart';

class CreatePage extends StatefulWidget {
  @override
  State createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
        title: Text('Create Critic'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    heroTag: 'fab_clear',
                    child: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      searchText = '';
                      searchController.clear();
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                Expanded(
                  flex: 7,
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
                        InputDecoration(hintText: 'Search movie or show'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FloatingActionButton(
                    heroTag: 'fab_send',
                    child: Icon(Icons.send),
                    onPressed: () {
                      if (searchText.length < 1) {
                        locator<ModalService>().showAlert(
                            context: context,
                            title: 'Error',
                            message: 'Cannot have empty search.');
                      } else {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => SearchResultsPage(
                        //       searchText: searchText,
                        //     ),
                        //   ),
                        // );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
