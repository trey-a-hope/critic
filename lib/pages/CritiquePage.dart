import 'package:critic/models/MovieModel.dart';
import 'package:critic/widgets/SideDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CritiquePage extends StatefulWidget {
  const CritiquePage({Key key, @required this.movie}) : super(key: key);

  final MovieModel movie;
  @override
  State createState() => CritiquePageState(movie: movie);
}

class CritiquePageState extends State<CritiquePage> {
  CritiquePageState({@required this.movie});
  final GetIt getIt = GetIt.I;
  final MovieModel movie;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Create Critique'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Critique ${movie.title}.'),
      ),
    );
  }
}
