import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants/app_themes.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';

import 'profile_view_model.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileViewModel>(
      init: ProfileViewModel(),
      builder: (model) => BasicPage(
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
                  Get.toNamed(
                    Globals.ROUTES_EDIT_PROFILE,
                    arguments: {
                      'uid': model.user!.uid,
                    },
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
                    model.isFollowing
                        ? ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            child: Text(
                              'Unfollow',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onPressed: () async {
                              model.unfollow();
                            },
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            child: Text(
                              'Follow',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              model.follow();
                            },
                          ),
                  ]
                ],
              ),
        title: 'Profile',
      ),
    );
  }
}
