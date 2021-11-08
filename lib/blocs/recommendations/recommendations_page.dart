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

  Future<List<MovieModel>> pageFetch(int offset) async {
    //Fetch template documents.
    List<DocumentSnapshot> documentSnapshots =
        await locator<UserService>().retrieveMoviesFromWatchlist(
      uid: context.read<RecommendationsBloc>().currentUser.uid!,
      limit: PAGE_FETCH_LIMIT,
      startAfterDocument:
          context.read<RecommendationsBloc>().startAfterDocument!,
    );

    //Return an empty list if there are no new documents.
    if (documentSnapshots.isEmpty) {
      return [];
    }

    context.read<RecommendationsBloc>().startAfterDocument =
        documentSnapshots[documentSnapshots.length - 1];

    List<MovieModel> movies = [];

    //Convert documents to template models.
    documentSnapshots.forEach((documentSnapshot) {
      MovieModel movieModel = MovieModel.fromDoc(data: documentSnapshot);
      movies.add(movieModel);
    });

    return movies;
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
              return RecommendationWidget(
                recommendation: recommendation,
                delete: () {
                  context.read<RecommendationsBloc>().add(
                        DeleteRecommendationEvent(
                            recommendationID: recommendation.id!),
                      );
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
