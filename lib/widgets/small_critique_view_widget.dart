import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timeago/timeago.dart' as timeago;

class SmallCritiqueViewWidget extends StatefulWidget {
  const SmallCritiqueViewWidget({
    Key? key,
    required this.critique,
  }) : super(key: key);

  /// The critique.
  final CritiqueModel critique;

  @override
  _SmallCritiqueViewWidgetState createState() =>
      _SmallCritiqueViewWidgetState();
}

class _SmallCritiqueViewWidgetState extends State<SmallCritiqueViewWidget> {
  /// The user who posted this critique.
  UserModel? user;

  /// Number of characters for message of the critique.
  int _critiqueMessageCharCount = 75;

  /// Instantiate user service.
  UserService _userService = Get.find();

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// Array that holds api calls for fetching the movie and user of this critique.
  List<Future> futures = [];

  @override
  void initState() {
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
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            }

            /// Set result to user object.
            UserModel user = snapshot.data[0];

            return Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        /// If the current user is the one who posted this critique, void this action.
                        if (user.uid == _getStorage.read('uid')) return;

                        ///TOD: Go to user page.
                      },
                      child: CachedNetworkImage(
                        imageUrl: '${user.imgUrl}',
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Text(
                      '${user.username}, ${timeago.format(widget.critique.created, allowFromNow: true)}',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.critique.message.length >
                                _critiqueMessageCharCount
                            ? '"${widget.critique.message}\"'.substring(
                                    0, _critiqueMessageCharCount + 1) +
                                '..."'
                            : '"${widget.critique.message}\"',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    RatingBarIndicator(
                      rating: widget.critique.rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 25.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
