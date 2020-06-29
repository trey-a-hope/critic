import 'package:critic/blocs/profile/Bloc.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final String timeFormat = 'MMM d, yyyy @ h:mm a';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    profileBloc = BlocProvider.of<ProfileBloc>(context);

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (BuildContext context, ProfileState state) {
        if (state is LoadingState) {
          return Spinner();
        }

        if (state is LoadedState) {
          return SingleChildScrollView(
            child: Stack(
              children: <Widget>[
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
                                        state.currentUser.username,
                                        style:
                                            Theme.of(context).textTheme.title,
                                      ),
                                      ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        title: Text(state.currentUser.email),
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
                                            DateFormat(timeFormat).format(
                                                state.currentUser.created),
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
                                  image: Image.network(state.currentUser.imgUrl)
                                      .image,
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
              ],
            ),
          );
        }
        
        return Container();
      },
    );
  }
}
