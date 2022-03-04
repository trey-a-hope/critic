import 'package:critic/ui/search_users/search_users_view_model.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:critic/ui/user_list_tile/user_list_tile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchUsersView extends StatelessWidget {
  SearchUsersView({Key? key}) : super(key: key);

  /// Editing controller for message on critique.
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchUsersViewModel>(
      init: SearchUsersViewModel(),
      builder: (model) => BasicPage(
        leftIconButton: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
        child: Column(
          children: [
            TextField(
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline6!.color),
              controller: _textController,
              autocorrect: false,
              onChanged: (text) {
                model.udpateSearchText(text: text);
              },
              cursorColor: Theme.of(context).textTheme.headline5!.color,
              decoration: InputDecoration(
                  errorStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  suffixIcon: GestureDetector(
                    child: Icon(
                      Icons.clear,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onTap: () {
                      _textController.clear();
                      model.udpateSearchText(text: '');
                    },
                  ),
                  border: InputBorder.none,
                  hintText: 'Enter username here...',
                  hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.headline6!.color)),
            ),
            model.isLoading
                ? Center(child: CircularProgressIndicator())
                : model.errorMessage != null
                    ? Center(child: Text(model.errorMessage!))
                    : model.users.isEmpty
                        ? Center(child: Text('No Results'))
                        : Expanded(
                            child: ListView.builder(
                              itemCount: model.users.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  UserListTile(
                                      user: model.users[index],
                                      returnUser: false),
                            ),
                          ),
          ],
        ),
        title: 'Search Users',
      ),
    );
  }
}
