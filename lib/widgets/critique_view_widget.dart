import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shimmer/shimmer.dart';

class CritiqueViewWidget extends StatefulWidget {
  const CritiqueViewWidget({
    Key? key,
    required this.critique,
  }) : super(key: key);

  /// The critique.
  final CritiqueModel critique;

  @override
  _CritiqueViewWidgetState createState() => _CritiqueViewWidgetState();
}

class _CritiqueViewWidgetState extends State<CritiqueViewWidget> {
  /// The movie associated with this critique.
  MovieModel? movie;

  /// The user who posted this critique.
  UserModel? user;

  /// Instantiate movie service.
  MovieService _movieService = Get.find();

  /// Instantiate user service.
  UserService _userService = Get.find();

  /// Array that holds api calls for fetching the movie and user of this critique.
  List<Future> futures = [];

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  @override
  void initState() {
    /// Add service call for fetching movie.
    futures.add(_movieService.getMovieByID(id: widget.critique.imdbID));

    /// Add service call for fetching user.
    futures.add(_userService.retrieveUser(uid: widget.critique.uid));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(futures),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
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
                                  'Test',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Divider(),
                                Text(
                                  '\"${widget.critique.message}\"',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                RatingBarIndicator(
                                  rating: widget.critique.rating,
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
                                    Text('John Doe',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    Spacer(),
                                    Text(
                                        '${timeago.format(widget.critique.created, allowFromNow: true)}',
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
                          'Posted  ',
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
            );

          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            }

            /// Set result to movie object.
            MovieModel movie = snapshot.data[0];

            /// Set result to user object.
            UserModel user = snapshot.data[1];

            return InkWell(
              onTap: () async {
                Get.toNamed(
                  Globals.ROUTES_MOVIE_DETAILS,
                  arguments: {
                    'movie': movie,
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
                            imageUrl: movie.poster,
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
                                  movie.title,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Divider(),
                                Text(
                                  '\"${widget.critique.message}\"',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                RatingBarIndicator(
                                  rating: widget.critique.rating,
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
                                            'uid': user.uid,
                                          },
                                        );
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: user.imgUrl,
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
                                      user.username,
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
                          widget.critique.created.isAfter(
                                  DateTime.now().subtract(Duration(days: 6)))
                              ? 'Posted ${timeago.format(widget.critique.created, allowFromNow: true)}'
                              : 'Posted ${DateFormat('MMM dd, yyyy').format(widget.critique.created)}',
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
                        _getStorage.read('uid') == user.uid
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
            );
        }
      },
    );
  }
}
