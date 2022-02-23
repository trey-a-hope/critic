import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants/app_themes.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/ui/critique_widget/critique_widget_view.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pagination_view/pagination_view.dart';

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
                      radius: 30,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('${model.followerCount} Followers',
                          style: AppThemes.textTheme.headline6),
                      Text(model.user!.username),
                      Text('${model.followingCount} Followings',
                          style: AppThemes.textTheme.headline6),
                    ],
                  ),
                  Divider(),
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
                  ],
                  Expanded(
                    child: RefreshIndicator(
                      child: PaginationView<CritiqueModel>(
                        initialLoader:
                            Center(child: CircularProgressIndicator()),
                        bottomLoader:
                            Center(child: CircularProgressIndicator()),
                        itemBuilder: (BuildContext context,
                                CritiqueModel critique, int index) =>
                            CritiqueWidgetView(
                          critique: critique,
                        ),
                        pageFetch: (int offset) async {
                          return model.fetchMyCritiques(offset);
                        },
                        onError: (dynamic error) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                size: 100,
                                color: Colors.grey,
                              ),
                              Text(
                                'Error',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                error.toString(),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                        onEmpty: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MdiIcons.movieEdit,
                                size: 100,
                                color: Colors.grey,
                              ),
                              Text(
                                '${Globals.MESSAGE_EMPTY_CRITIQUES}',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ],
                          ),
                        ),
                        paginationViewType: PaginationViewType.listView,
                      ),
                      onRefresh: () async {
                        model.resetLastIDs();
                        return;
                      },
                    ),
                  ),
                ],
              ),
        title: 'Profile',
      ),
    );
  }
}
