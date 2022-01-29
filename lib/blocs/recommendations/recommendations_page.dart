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
          final List<RecommendationTuple> recommendationTuples =
              state.recommendationTuples;
          return ListView.builder(
            itemCount: recommendationTuples.length,
            itemBuilder: (BuildContext context, int index) {
              final RecommendationTuple recommendationTuple =
                  recommendationTuples[index];
              return RecommendationWidget(
                recommendationTuple: recommendationTuple,
                delete: () {
                  context.read<RecommendationsBloc>().add(
                        DeleteRecommendationEvent(
                          recommendationID:
                              recommendationTuple.recommendation.id!,
                        ),
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
