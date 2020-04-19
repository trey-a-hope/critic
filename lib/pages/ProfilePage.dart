import 'package:critic/models/UserModel.dart';
import 'package:critic/pages/EditProfilePage.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/widgets/GoodButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../ServiceLocator.dart';

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final String timeFormat = 'MMM d, yyyy @ h:mm a';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locator<AuthService>().getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Spinner();
            break;
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error.toString()}'),
              );
            }

            UserModel currentUser = snapshot.data;

            return SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  // SizedBox(
                  //   height: 250,
                  //   width: double.infinity,
                  //   child: Image.network(
                  //       'https://images.unsplash.com/photo-1535016120720-40c646be5580?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80'),
                  // ),
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1535016120720-40c646be5580?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80'),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(16.0),
                              margin: EdgeInsets.only(top: 20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 110.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          currentUser.username,
                                          style:
                                              Theme.of(context).textTheme.title,
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text(currentUser.email),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: <Widget>[
                                      // Expanded(
                                      //   child: Column(
                                      //     children: <Widget>[
                                      //       Text(
                                      //         '${_gemLikes.length}',
                                      //         style: TextStyle(fontWeight: FontWeight.bold),
                                      //       ),
                                      //       Text(_gemLikes.length == 1 ? 'Like' : 'Likes')
                                      //     ],
                                      //   ),
                                      // ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              DateFormat(timeFormat)
                                                  .format(currentUser.created),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('Joined')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2.0, color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                    image:
                                        Image.network(currentUser.imgUrl).image,
                                    fit: BoxFit.cover),
                              ),
                              margin: EdgeInsets.only(left: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: FloatingActionButton(
                      child: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              currentUser: currentUser,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
        }
      },
    );
  }
}
