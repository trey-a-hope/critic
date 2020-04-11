import 'package:critic/models/MovieModel.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/widgets/SideDrawer.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pagination/pagination.dart';

class FindMoviePage extends StatefulWidget {
  @override
  State createState() => FindMoviePageState();
}

class FindMoviePageState extends State<FindMoviePage> {
  final GetIt getIt = GetIt.I;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int page = 1;
  bool endPageFetch = false;
  @override
  void initState() {
    super.initState();
  }

  Future<List<MovieModel>> pageFetch(int offset) async {
    if (!endPageFetch) {
      List<MovieModel> movies = await getIt<IMovieService>()
          .getMovieBySearch(search: 'The', page: page);

      if (movies.isEmpty) endPageFetch = true;

      page = page + 1;

      return movies;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Find Movie'),
        centerTitle: true,
      ),
      drawer: SideDrawer(
        page: 'Find Movie',
      ),
      body: PaginationList<MovieModel>(
        onLoading: Spinner(),
        onPageLoading: Spinner(),
        separatorWidget: Divider(),
        itemBuilder: (BuildContext context, MovieModel movie) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(movie.poster),
            ),
            title: Text('${movie.title}'),
            subtitle: Text('What should go here?'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {},
          );
        },
        pageFetch: pageFetch,
        onError: (dynamic error) => Center(
          child: Text('Something Went Wrong'),
        ),
        onEmpty: Center(
          child: Text('Empty List'),
        ),
      ),
    );
  }
}
