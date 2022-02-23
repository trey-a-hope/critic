import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shimmer/shimmer.dart';

import 'critique_widget_view_model.dart';

class CritiqueWidgetView extends StatelessWidget {
  CritiqueWidgetView({required this.critique});

  final CritiqueModel critique;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CritiqueWidgetViewModel>(
      tag: critique.id,
      init: CritiqueWidgetViewModel(critique: critique),
      builder: (model) => model.isLoading
          ? Shimmer.fromColors(
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
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(5.0, 5.0),
                                      blurRadius: 10.0)
                                ],
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    Spacer(),
                                    Text('',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
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
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(5.0, 5.0),
                                    blurRadius: 10.0)
                              ],
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
                            Icons.ios_share,
                          ),
                          onPressed: () {},
                        ),
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
            )
          : InkWell(
              onTap: () async {
                Get.toNamed(
                  Globals.ROUTES_MOVIE_DETAILS,
                  arguments: {
                    'movie': model.movie,
                  },
                );
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 200,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 130,
                          child: CachedNetworkImage(
                            imageUrl: model.movie.poster,
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
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(5.0, 5.0),
                                      blurRadius: 10.0)
                                ],
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  model.movie.title,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Divider(),
                                Text(
                                  '\"${critique.message}\"',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                RatingBarIndicator(
                                  rating: critique.rating,
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
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          Globals.ROUTES_PROFILE,
                                          arguments: {
                                            'uid': model.user.uid,
                                          },
                                        );
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: model.user.imgUrl,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 15,
                                          backgroundImage: imageProvider,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      model.user.username,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
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
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(5.0, 5.0),
                                    blurRadius: 10.0)
                              ],
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
                          critique.created.isAfter(
                                  DateTime.now().subtract(Duration(days: 6)))
                              ? 'Posted ${timeago.format(critique.created, allowFromNow: true)}'
                              : 'Posted ${DateFormat('MMM dd, yyyy').format(critique.created)}',
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: true ? Colors.grey : Colors.red,
                          ),
                          onPressed: () {
                            Get.snackbar(
                              'TODO',
                              'Favorite critique.',
                              icon: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.ios_share,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Get.snackbar(
                              'TODO',
                              'Share critique.',
                              icon: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                        ),
                        model.postedByMe
                            ? IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  Get.snackbar(
                                    'TODO',
                                    'Delete critique.',
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
                            : IconButton(
                                icon: Icon(
                                  Icons.report,
                                  color: Colors.grey,
                                ),
                                onPressed: () {},
                              )
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
    );
  }
}