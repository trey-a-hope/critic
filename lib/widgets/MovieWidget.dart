import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/critiqueDetails/Bloc.dart' as CRITIQUE_DETAILS_BP;
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/createCritique/Bloc.dart' as CREATE_CRITIQUE_BP;

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
