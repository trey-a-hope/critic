part of 'create_recommendation_bloc.dart';

class CreateRecommendationPage extends StatefulWidget {
  @override
  State createState() => _CreateRecommendationPageState();
}

class _CreateRecommendationPageState extends State<CreateRecommendationPage> {
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recommendation'),
      ),
      body: BlocBuilder<CreateRecommendationBloc, CreateRecommendationState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is LoadedState) {
            final MovieModel? selectedMovie = state.selectedMovie;
            final UserModel? selectedUser = state.selectedUser;

            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                cursorColor: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .color,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _messageController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                validator: locator<ValidationService>().isEmpty,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .color,
                                ),
                                maxLines: 1,
                                maxLength: 50,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .color),
                                  counterStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .color),
                                  hintText: 'Write a quick message...',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .color),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).iconTheme.color),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Text(
                              selectedMovie == null
                                  ? 'Pick Movie'
                                  : '${selectedMovie.title}\nPick A Different Movie?',
                              textAlign: TextAlign.center),
                          onPressed: () async {
                            Route route = MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    SEARCH_MOVIES_BP.SearchMoviesBloc(
                                  searchMoviesRepository:
                                      SEARCH_MOVIES_BP.SearchMoviesRepository(
                                    cache: SEARCH_MOVIES_BP.SearchMoviesCache(),
                                  ),
                                ),
                                child: SEARCH_MOVIES_BP.SearchMoviesPage(
                                  returnMovie: true,
                                ),
                              ),
                            );

                            final result = await Navigator.push(context, route);

                            final movie = result as MovieModel?;

                            if (movie != null) {
                              context
                                  .read<CreateRecommendationBloc>()
                                  .add(UpdateSelectedMovieEvent(movie: movie));
                            }
                          },
                        ),
                      ),
                      selectedMovie != null
                          ? Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                child: CachedNetworkImage(
                                  imageUrl: '${selectedMovie.poster}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).iconTheme.color),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Text(
                              selectedMovie == null
                                  ? 'Pick Movie'
                                  : '${selectedMovie.title}\nPick A Different Movie?',
                              textAlign: TextAlign.center),
                          onPressed: () async {
                            Route route = MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) =>
                                    SEARCH_USERS_BP.SearchUsersBloc(
                                  searchUsersRepository:
                                      SEARCH_USERS_BP.SearchUsersRepository(
                                    cache: SEARCH_USERS_BP.SearchUsersCache(),
                                  ),
                                )..add(SEARCH_USERS_BP.LoadPageEvent()),
                                child: SEARCH_USERS_BP.SearchUsersPage(
                                  returnUser: true,
                                ),
                              ),
                            );

                            final result = await Navigator.push(context, route);

                            final user = result as UserModel?;

                            if (user != null) {
                              context.read<CreateRecommendationBloc>().add(
                                    UpdateSelectedUserEvent(user: user),
                                  );
                            }
                          },
                        ),
                      ),
                      selectedUser != null
                          ? Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                child: CachedNetworkImage(
                                  imageUrl: '${selectedUser.imgUrl}',
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 100,
                                    backgroundImage: imageProvider,
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).iconTheme.color),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Text('Send Recommendation'),
                    onPressed: () async {
                      if (selectedUser == null || selectedMovie == null) {
                        return;
                      }

                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final bool? confirm = await locator<ModalService>()
                          .showConfirmation(
                              context: context,
                              title: 'Send Recommendation',
                              message: 'Are you sure?');

                      if (confirm == null || !confirm) return;

                      context.read<CreateRecommendationBloc>().add(
                            SubmitRecommendationEvent(
                                message: _messageController.text),
                          );
                    },
                  ),
                ),
              ],
            );
          }

          if (state is SuccessState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.thumbUp,
                    size: 100,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Text(
                    'Recommendation sent successfully!',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Text('You should NEVER see this.'),
          );
        },
      ),
    );
  }
}
