import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/ui/search_users/search_users_view_model.dart';
import 'package:critic/widgets/basic_page.dart';
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
                              itemBuilder: (BuildContext context, int index) {
                                final UserModel user = model.users[index];

                                return ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl: user.imgUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Image(
                                      image: imageProvider,
                                      height: 100,
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  title: Text(
                                    user.username,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  subtitle: Text(
                                    user.email,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  onTap: () async {
                                    if (model.returnUser) {
                                      /// Return user to previous screen.
                                      Get.back(result: user);
                                    } else {
                                      /// Go to profile screen.
                                      Get.toNamed(
                                        Globals.ROUTES_PROFILE,
                                        arguments: {
                                          'uid': user.uid,
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
          ],
        ),
        title: 'Search Users',
      ),
    );
  }
}
