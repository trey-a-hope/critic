import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/SearchQueryModel.dart';
import 'package:critic/pages/MovieDetailsPage.dart';
import 'package:critic/pages/SearchResultsPage.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/widgets/GoodButton.dart';
import 'package:critic/widgets/SideDrawer.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pagination/pagination.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class CreatePage extends StatefulWidget {
  @override
  State createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String searchText = '';
  final TextEditingController searchController = TextEditingController();
  final IModalService modalService = GetIt.I<IModalService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  decoration: InputDecoration(hintText: 'Search movie or show'),
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
                      modalService.showAlert(
                          context: context,
                          title: 'Error',
                          message: 'Cannot have empty search.');
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
              )
            ],
          ),
        ),
      ],
    );
  }
}
