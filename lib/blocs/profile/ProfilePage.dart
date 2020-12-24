import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/followers/Bloc.dart' as FOLLOWERS_BP;
import 'package:critic/blocs/followings/Bloc.dart' as FOLLOWINGS_BP;
import 'package:critic/blocs/profile/Bloc.dart' as PROFILE_BP;
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/widgets/SmallCritiqueView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pagination/pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    implements PROFILE_BP.ProfileBlocDelegate {
  PROFILE_BP.ProfileBloc _profileBloc;

  @override
  void initState() {
    _profileBloc = BlocProvider.of<PROFILE_BP.ProfileBloc>(context);
    _profileBloc.setDelegate(delegate: this);

    super.initState();
  }

  Future<List<CritiqueModel>> pageFetch(int offset) async {
    //Fetch template documents.
    List<DocumentSnapshot> documentSnapshots =
        await locator<CritiqueService>().retrieveCritiquesFromFirebase(
      uid: _profileBloc.currentUser.uid,
      limit: _profileBloc.limit,
      startAfterDocument: _profileBloc.startAfterDocument,
    );

    //Return an empty list if there are no new documents.
    if (documentSnapshots.isEmpty) {
      return [];
    }

    _profileBloc.startAfterDocument =
        documentSnapshots[documentSnapshots.length - 1];

    List<CritiqueModel> critiques = [];

    //Convert documents to template models.
    documentSnapshots.forEach((documentSnapshot) {
      CritiqueModel critiqueModel = CritiqueModel.fromDoc(ds: documentSnapshot);
      critiques.add(critiqueModel);
    });

    return critiques;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PROFILE_BP.ProfileBloc, PROFILE_BP.ProfileState>(
      builder: (BuildContext context, PROFILE_BP.ProfileState state) {
        if (state is PROFILE_BP.LoadingState) {
          return Spinner();
        }

        if (state is PROFILE_BP.LoadedState) {
          final UserModel currentUser = state.currentUser;
          final int followerCount = state.followerCount;
          final int followingCount = state.followingCount;

          return Scaffold(
            backgroundColor: Colors.white,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: colorNavy,
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        '${currentUser.username}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                            image: AssetImage('assets/images/theater.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: '${currentUser.imgUrl}',
                                  imageBuilder: (context, imageProvider) =>
                                      GFAvatar(
                                    radius: 40,
                                    backgroundImage: imageProvider,
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                Positioned(
                                  bottom: 1,
                                  right: 1,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.red,
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(
                                          MdiIcons.camera,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          showSelectImageDialog();
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      '${currentUser.critiqueCount} Critiques',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: InkWell(
                                      child: Text(
                                        '$followerCount Followers',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Route route = MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => FOLLOWERS_BP
                                                .FollowersBloc(
                                                    user: currentUser)
                                              ..add(
                                                FOLLOWERS_BP.LoadPageEvent(),
                                              ),
                                            child: FOLLOWERS_BP.FollowersPage(),
                                          ),
                                        );

                                        Navigator.push(context, route);
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: InkWell(
                                      child: Text(
                                        '$followingCount Followings',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Route route = MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => FOLLOWINGS_BP
                                                .FollowingsBloc(
                                                    user: currentUser)
                                              ..add(
                                                FOLLOWINGS_BP.LoadPageEvent(),
                                              ),
                                            child:
                                                FOLLOWINGS_BP.FollowingsPage(),
                                          ),
                                        );

                                        Navigator.push(context, route);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                child: PaginationList<CritiqueModel>(
                  onLoading: Spinner(),
                  onPageLoading: Spinner(),
                  separatorWidget: Divider(
                    height: 0,
                    color: Theme.of(context).dividerColor,
                  ),
                  itemBuilder: (BuildContext context, CritiqueModel critique) {
                    return SmallCritiqueView(
                      critique: critique,
                      currentUser: currentUser,
                    );
                  },
                  pageFetch: pageFetch,
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
                          '$MESSAGE_EMPTY_CRITIQUES',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ),
                onRefresh: () {
                  _profileBloc.add(
                    PROFILE_BP.LoadPageEvent(),
                  );

                  return;
                },
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  showSelectImageDialog() {
    return Platform.isIOS ? iOSBottomSheet() : androidDialog();
  }

  iOSBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () {
                  Navigator.pop(context);
                  _profileBloc.add(
                    PROFILE_BP.UploadImageEvent(
                        imageSource: ImageSource.camera),
                  );
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Choose From Gallery'),
                onPressed: () {
                  Navigator.pop(context);
                  _profileBloc.add(
                    PROFILE_BP.UploadImageEvent(
                        imageSource: ImageSource.gallery),
                  );
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add Photo'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  Navigator.pop(context);
                  _profileBloc.add(
                    PROFILE_BP.UploadImageEvent(
                        imageSource: ImageSource.camera),
                  );
                },
              ),
              SimpleDialogOption(
                child: Text('Choose From Gallery'),
                onPressed: () {
                  Navigator.pop(context);
                  _profileBloc.add(
                    PROFILE_BP.UploadImageEvent(
                        imageSource: ImageSource.gallery),
                  );
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>().showAlert(
      context: context,
      title: 'Error',
      message: message,
    );
  }
}
