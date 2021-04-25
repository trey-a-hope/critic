import 'package:critic/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/create_critique/create_critique_bloc.dart'
    as CREATE_CRITIQUE_BP;

class MovieWidget extends StatefulWidget {
  const MovieWidget({
    Key key,
    @required this.movie,
  }) : super(key: key);

  final MovieModel movie;

  @override
  State createState() => _MovieWidgetState(
        movie: movie,
      );
}

class _MovieWidgetState extends State<MovieWidget> {
  _MovieWidgetState({
    @required this.movie,
  });

  final MovieModel movie;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Route route = MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CREATE_CRITIQUE_BP.CreateCritiqueBloc(
              movie: movie,
            )..add(
                CREATE_CRITIQUE_BP.LoadPageEvent(),
              ),
            child: CREATE_CRITIQUE_BP.CreateCritiquePage(),
          ),
        );

        Navigator.push(context, route);
      },
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.darken),
            image: NetworkImage(movie.poster),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            '${movie.title}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
