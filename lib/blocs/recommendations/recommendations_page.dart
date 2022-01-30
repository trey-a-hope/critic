part of 'recommendations_bloc.dart';

class RecommendationsPage extends StatefulWidget {
  @override
  State createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage>
    implements RecommendationsBlocDelegate {
  @override
  void initState() {
    context.read<RecommendationsBloc>().setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationsBloc, RecommendationsState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return Spinner();
        }

        if (state is EmptyRecommendationsState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.message,
                  size: 100,
                  color: Theme.of(context).iconTheme.color,
                ),
                Text(
                  'Currently no recommendations.',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          );
        }

        if (state is LoadedState) {
          final List<RecommendationModel> recommendations =
              state.recommendations;
          return ListView.builder(
            itemCount: recommendations.length,
            itemBuilder: (BuildContext context, int index) {
              final RecommendationModel recommendation = recommendations[index];

              //Send future to fetch the movie and user associated with the critique.
              Future<UserModel> userFuture =
                  locator<UserService>().retrieveUser(uid: recommendation.uid);
              Future<MovieModel> movieFuture = locator<MovieService>()
                  .getMovieByID(id: recommendation.imdbID);

              return FutureBuilder(
                future: Future.wait([userFuture, movieFuture]),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error ${snapshot.error.toString()}'),
                        );
                      }

                      UserModel user = snapshot.data![0] as UserModel;
                      MovieModel movie = snapshot.data![1] as MovieModel;

                      return RecommendationWidget(
                        movie: movie,
                        user: user,
                        recommendation: recommendation,
                        delete: () {
                          context.read<RecommendationsBloc>().add(
                                DeleteRecommendationEvent(
                                  recommendationID: recommendation.id!,
                                ),
                              );
                        },
                      );
                  }
                },
              );
            },
          );
        }

        return Center(
          child: Text('You should NEVER see this.'),
        );
      },
    );
  }

  @override
  void showMessage({
    required String message,
  }) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }
}
