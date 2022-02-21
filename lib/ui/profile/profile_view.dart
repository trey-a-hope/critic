import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants/app_themes.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';

import 'profile_view_model.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileViewModel>(
      init: ProfileViewModel(),
      builder: (model) => BasicPage(
        scaffoldKey: _scaffoldKey,
        leftIconButton: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
        rightIconButton: model.isMyProfile
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Get.snackbar(
                    'TODO',
                    'Go to edit profile page.',
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              )
            : null,
        child: model.user == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: model.user!.imgUrl,
                    imageBuilder: (context, imageProvider) => GFAvatar(
                      radius: 40,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Text(model.user!.username),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('${model.user!.followers.length} Followers',
                          style: AppThemes.textTheme.headline6),
                      Text('${model.user!.followings.length} Followings',
                          style: AppThemes.textTheme.headline6),
                    ],
                  ),
                  if (!model.isMyProfile) ...[
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'Follow',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () async {},
                    ),
                  ]
                ],
              ),
        title: 'Profile',
      ),
    );
  }
}
