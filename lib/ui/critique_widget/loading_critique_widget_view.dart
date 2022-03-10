import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

/// Used only to display a critique view that is loading.
class LoadingCritiqueWidgetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            margin: EdgeInsets.only(bottom: 20.0),
            height: 200,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 130,
                  child: CachedNetworkImage(
                    imageUrl: Globals.DUMMY_POSTER_IMG_URL,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitHeight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Divider(),
                        Text(
                          '',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        RatingBarIndicator(
                          rating: 0,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        Spacer(),
                        Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: Globals.DUMMY_PROFILE_PHOTO_URL,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 15,
                                backgroundImage: imageProvider,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            Text('',
                                style: Theme.of(context).textTheme.headline6),
                            Spacer(),
                            Text('',
                                style: Theme.of(context).textTheme.headline6),
                          ],
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  '',
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.report,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
