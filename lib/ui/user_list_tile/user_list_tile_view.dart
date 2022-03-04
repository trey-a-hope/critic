import 'package:critic/constants/globals.dart';
import 'package:critic/ui/user_list_tile/user_list_tile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({
    Key? key,
    required this.user,
    required this.returnUser,
  }) : super(key: key);

  /// The user of the list tile.
  final UserModel user;

  /// If true, return user. Otherwise, open user profile page.
  final bool returnUser;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserListTileViewModel>(
      tag: user.uid,
      init: UserListTileViewModel(),
      builder: (model) => ListTile(
        leading: CachedNetworkImage(
          imageUrl: user.imgUrl,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        title: Text(
          user.username,
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).iconTheme.color,
        ),
        onTap: () async {
          if (returnUser) {
            // Return user to previous screen.
            Get.back(result: user);
          } else {
            // Go to profile screen.
            Get.toNamed(
              Globals.ROUTES_PROFILE,
              arguments: {
                'uid': user.uid,
              },
            );
          }
        },
      ),
    );
  }
}
