import 'package:critic/Constants.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/pages/CritiquePage.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/widgets/GoodButton.dart';
import 'package:critic/widgets/SideDrawer.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({Key key, @required this.imdbID}) : super(key: key);
  final String imdbID;

  @override
  State createState() => MovieDetailsPageState(imdbID: imdbID);
}

class MovieDetailsPageState extends State<MovieDetailsPage> {
  MovieDetailsPageState({@required this.imdbID});
  final String imdbID;
  final GetIt getIt = GetIt.I;
  double imageSize;
  final double listViewBuilderPadding = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Details',
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getIt<IMovieService>().getMovieByID(id: imdbID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Spinner();
              break;
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error.toString()}'),
                );
              }

              MovieModel movie = snapshot.data;
              return ListView(
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.6,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(movie.poster),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${movie.title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${movie.year}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Directed by ${movie.director}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' ${movie.imdbRating} / 10 ( ${movie.imdbVotes} votes ) IMDB Rating',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: GoodButton(
                      title: 'Write Critique',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CritiquePage(
                              movie: movie,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: <Widget>[
                  //     Text(
                  //       'Write Critique',
                  //       style:
                  //           TextStyle(color: Colors.white, letterSpacing: 2.0),
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     FloatingActionButton(
                  //       heroTag: 'fab',
                  //       child: Icon(
                  //         Icons.note_add,
                  //         size: 30,
                  //       ),
                  //       onPressed: () {
                  //         Navigator.of(context).push(
                  //           MaterialPageRoute(
                  //             builder: (context) => CritiquePage(
                  //               movie: movie,
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
          }
        },
      ),
    );

    // imageSize = screenHeight * 0.5;

    // return Scaffold(
    //   // appBar: AppBar(
    //   //   backgroundColor: Colors.black,
    //   //   title: Text('Home'),
    //   //   centerTitle: true,
    //   // ),
    //   // drawer: SideDrawer(
    //   //   page: 'Home',
    //   // ),
    //   backgroundColor: Colors.white,
    //   body: FutureBuilder(
    //     future: getIt<IMovieService>().getMovieByID(id: imdbID),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.waiting:
    //           return Spinner();
    //           break;
    //         default:
    //           if (snapshot.hasError) {
    //             return Center(
    //               child: Text('Error: ${snapshot.error.toString()}'),
    //             );
    //           }

    //           MovieModel movie = snapshot.data;

    //           return ListView(children: [
    //             Stack(
    //               children: <Widget>[
    //                 // Container(
    //                 //   // color: Colors.white,
    //                 //   width: screenWidth,
    //                 //   height: screenHeight * 0.6,
    //                 //   decoration: BoxDecoration(
    //                 //     borderRadius: BorderRadius.only(
    //                 //         bottomLeft: Radius.circular(40),
    //                 //         bottomRight: Radius.circular(40)),
    //                 //     image: DecorationImage(
    //                 //       colorFilter: ColorFilter.mode(
    //                 //           Colors.black.withOpacity(0.6), BlendMode.darken),
    //                 //       image: NetworkImage(movie.poster),
    //                 //       fit: BoxFit.fill,
    //                 //     ),
    //                 //   ),
    //                 // ),
    //                 // Positioned(
    //                 //   top: imageSize,
    //                 //   child: Container(
    //                 //     height: screenHeight - imageSize,
    //                 //     width: screenWidth,
    //                 //     color: Colors.black,
    //                 //     // decoration: BoxDecoration(
    //                 //     //   color: Colors.greenAccent,
    //                 //     //   borderRadius: BorderRadius.all(
    //                 //     //     Radius.circular(40),
    //                 //     //   ),
    //                 //     // ),
    //                 //     child: Padding(
    //                 //       padding: EdgeInsets.only(top: listViewBuilderPadding),
    //                 //       child: Container(
    //                 //         height: screenHeight -
    //                 //             imageSize +
    //                 //             listViewBuilderPadding,
    //                 //         width: screenWidth,
    //                 //         child: Padding(
    //                 //           padding: EdgeInsets.symmetric(horizontal: 20),
    //                 //           child: Center(
    //                 //             child: Column(
    //                 //               crossAxisAlignment: CrossAxisAlignment.center,
    //                 //               children: <Widget>[
    //                 //                 // SizedBox(
    //                 //                 //   height: 125,
    //                 //                 // ),
    //                 //                 // Text(
    //                 //                 //   '${movie.title}',
    //                 //                 //   textAlign: TextAlign.center,
    //                 //                 //   style: TextStyle(
    //                 //                 //       fontSize: 25,
    //                 //                 //       color: Colors.white,
    //                 //                 //       fontWeight: FontWeight.bold),
    //                 //                 // ),
    //                 //                 // Text(
    //                 //                 //   '${movie.year}',
    //                 //                 //   textAlign: TextAlign.center,
    //                 //                 //   style: TextStyle(
    //                 //                 //     fontSize: 25,
    //                 //                 //     color: Colors.grey[500],
    //                 //                 //   ),
    //                 //                 // ),
    //                 //                 // SizedBox(
    //                 //                 //   height: 10,
    //                 //                 // ),
    //                 //                 // Wrap(
    //                 //                 //   children: <Widget>[
    //                 //                 //     Text(
    //                 //                 //       'Directed by',
    //                 //                 //       style: TextStyle(
    //                 //                 //           fontSize: 14,
    //                 //                 //           color: Colors.grey[300],
    //                 //                 //           fontWeight: FontWeight.bold),
    //                 //                 //     ),
    //                 //                 //     Text(
    //                 //                 //       ' ${movie.director}',
    //                 //                 //       style: TextStyle(
    //                 //                 //         fontSize: 14,
    //                 //                 //         color: Colors.grey[500],
    //                 //                 //       ),
    //                 //                 //     )
    //                 //                 //   ],
    //                 //                 // ),
    //                 //                 // SizedBox(
    //                 //                 //   height: 10,
    //                 //                 // ),
    //                 //                 // Wrap(
    //                 //                 //   children: <Widget>[
    //                 //                 //     Icon(
    //                 //                 //       Icons.star,
    //                 //                 //       color: Colors.yellow,
    //                 //                 //     ),
    //                 //                 //     Text(
    //                 //                 //       ' ${movie.imdbRating} (${movie.imdbVotes})',
    //                 //                 //       style: TextStyle(
    //                 //                 //           fontSize: 14,
    //                 //                 //           color: Colors.grey[300],
    //                 //                 //           fontWeight: FontWeight.bold),
    //                 //                 //     ),
    //                 //                 //     Text(
    //                 //                 //       ' IMDB Rating',
    //                 //                 //       style: TextStyle(
    //                 //                 //         fontSize: 14,
    //                 //                 //         color: Colors.grey[500],
    //                 //                 //       ),
    //                 //                 //     )
    //                 //                 //   ],
    //                 //                 // ),
    //                 //                 // Divider(
    //                 //                 //   color: Colors.white,
    //                 //                 // ),
    //                 //                 // Padding(
    //                 //                 //   padding:
    //                 //                 //       EdgeInsets.symmetric(vertical: 10),
    //                 //                 //   child: Text(
    //                 //                 //     '0 people have critiqued this movie...',
    //                 //                 //     style: TextStyle(color: Colors.white),
    //                 //                 //   ),
    //                 //                 // ),
    //                 //                 // Divider(
    //                 //                 //   color: Colors.white,
    //                 //                 // ),
    //                 //                 // SizedBox(
    //                 //                 //   height: 30,
    //                 //                 // ),
    //                 //                 // Row(
    //                 //                 //   mainAxisAlignment: MainAxisAlignment.end,
    //                 //                 //   children: <Widget>[
    //                 //                 //     Text(
    //                 //                 //       'Write Critique',
    //                 //                 //       style: TextStyle(
    //                 //                 //           color: Colors.white,
    //                 //                 //           letterSpacing: 2.0),
    //                 //                 //     ),
    //                 //                 //     SizedBox(
    //                 //                 //       width: 10,
    //                 //                 //     ),
    //                 //                 //     FloatingActionButton(
    //                 //                 //       heroTag: 'fab',
    //                 //                 //       child: Icon(
    //                 //                 //         Icons.note_add,
    //                 //                 //         size: 30,
    //                 //                 //       ),
    //                 //                 //       onPressed: () {
    //                 //                 //         Navigator.of(context).push(
    //                 //                 //           MaterialPageRoute(
    //                 //                 //             builder: (context) =>
    //                 //                 //                 CritiquePage(
    //                 //                 //               movie: movie,
    //                 //                 //             ),
    //                 //                 //           ),
    //                 //                 //         );
    //                 //                 //       },
    //                 //                 //     ),
    //                 //                 //   ],
    //                 //                 // ),
    //                 //                 // SizedBox(
    //                 //                 //   height: 20,
    //                 //                 // )
    //                 //               ],
    //                 //             ),
    //                 //           ),
    //                 //         ),
    //                 //       ),
    //                 //     ),
    //                 //   ),
    //                 // ),
    //                 Stack(
    //                   children: <Widget>[
    //                     Container(
    //                       height: screenHeight * 0.6,
    //                       width: screenWidth,
    //                       decoration: BoxDecoration(
    //                         // borderRadius: BorderRadius.only(
    //                         //     bottomLeft: Radius.circular(40),
    //                         //     bottomRight: Radius.circular(40)),
    //                         image: DecorationImage(
    //                           image: NetworkImage(movie.poster == 'N/A'
    //                               ? DUMMY_POSTER_IMG_URL
    //                               : movie.poster),
    //                           fit: BoxFit.contain,
    //                         ),
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: <Widget>[
    //                           FloatingActionButton(
    //                             child: Icon(
    //                               Icons.chevron_left,
    //                               size: 30,
    //                             ),
    //                             onPressed: () {
    //                               Navigator.of(context).pop();
    //                             },
    //                           ),
    //                           // Text(
    //                           //   'Details',
    //                           //   style: TextStyle(
    //                           //       fontSize: 18,
    //                           //       color: Colors.white,
    //                           //       fontWeight: FontWeight.bold),
    //                           // ),
    //                           IconButton(
    //                             icon: Icon(
    //                               Icons.refresh,
    //                               color: Colors.white.withOpacity(0),
    //                             ),
    //                             onPressed: () {
    //                               //Navigator.of(context).pop();
    //                             },
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             Container(
    //               height: 320,
    //               child: Column(
    //                 children: <Widget>[
    //                   SizedBox(
    //                     height: 20,
    //                   ),
    //                   Text(
    //                     '${movie.title}',
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                         fontSize: 25,
    //                         color: Colors.black,
    //                         fontWeight: FontWeight.bold),
    //                   ),
    //                   Text(
    //                     '${movie.year}',
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       fontSize: 25,
    //                       color: Colors.grey[500],
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Text(
    //                     'Directed by ${movie.director}',
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                         fontSize: 14,
    //                         color: Colors.grey[700],
    //                         fontWeight: FontWeight.bold),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                     children: <Widget>[
    //                       Row(
    //                         children: <Widget>[
    //                           Icon(
    //                             Icons.star,
    //                             color: Colors.yellow,
    //                           ),
    //                           Text(
    //                             ' ${movie.imdbRating} (${movie.imdbVotes})',
    //                             style: TextStyle(
    //                                 fontSize: 14,
    //                                 color: Colors.grey[500],
    //                                 fontWeight: FontWeight.bold),
    //                           ),
    //                           Text(
    //                             ' IMDB Rating',
    //                             style: TextStyle(
    //                               fontSize: 14,
    //                               color: Colors.grey[700],
    //                             ),
    //                           )
    //                         ],
    //                       )
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 30,
    //                   ),
    //                   Padding(
    //                     padding: EdgeInsets.symmetric(horizontal: 20),
    //                     child: GoodButton(
    //                       title: 'Write Critique',
    //                       onTap: () {
    //                         Navigator.of(context).push(
    //                           MaterialPageRoute(
    //                             builder: (context) => CritiquePage(
    //                               movie: movie,
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                   ),
    //                   // Row(
    //                   //   mainAxisAlignment: MainAxisAlignment.end,
    //                   //   children: <Widget>[
    //                   //     Text(
    //                   //       'Write Critique',
    //                   //       style: TextStyle(color: Colors.white, letterSpacing: 2.0),
    //                   //     ),
    //                   //     SizedBox(
    //                   //       width: 10,
    //                   //     ),
    //                   //     FloatingActionButton(
    //                   //       heroTag: 'fab',
    //                   //       child: Icon(
    //                   //         Icons.note_add,
    //                   //         size: 30,
    //                   //       ),
    //                   //       onPressed: () {
    //                   //         Navigator.of(context).push(
    //                   //           MaterialPageRoute(
    //                   //             builder: (context) => CritiquePage(
    //                   //               movie: movie,
    //                   //             ),
    //                   //           ),
    //                   //         );
    //                   //       },
    //                   //     ),
    //                   //   ],
    //                   // ),
    //                   SizedBox(
    //                     height: 20,
    //                   )
    //                 ],
    //               ),
    //             )
    //           ]);
    //       }
    //     },
    //   ),
    // );
  }
}