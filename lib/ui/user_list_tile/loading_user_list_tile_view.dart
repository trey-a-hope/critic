import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Used only to display a user list tile that is loading.
class LoadingUserListTileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: Globals.DUMMY_PROFILE_PHOTO_URL,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        title: Text(
          '',
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).iconTheme.color,
        ),
        onTap: () async {},
      ),
    );
  }
}
