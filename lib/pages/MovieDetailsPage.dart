import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/createCritique/Bloc.dart' as CREATE_CRITIQUE_BP;
import 'package:critic/models/MovieModel.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailsPage extends StatelessWidget {
  MovieDetailsPage({@required this.imdbID});
  final String imdbID;
  final double listViewBuilderPadding = 10;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: locator<MovieService>().getMovieByID(id: imdbID),
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
                    child: FullWidthButton(
                      textColor: Colors.white,
                      buttonColor: Colors.red,
                      text: 'Write Critique',
                      onPressed: () {
                        Route route = MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                CREATE_CRITIQUE_BP.CreateCritiqueBloc(
                                    movie: movie)
                                  ..add(
                                    CREATE_CRITIQUE_BP.LoadPageEvent(),
                                  ),
                            child: CREATE_CRITIQUE_BP.CreateCritiquePage(),
                          ),
                        );

                        Navigator.push(context, route);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
          }
        },
      ),
    );
  }
}
