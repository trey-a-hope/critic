part of 'create_critique_bloc.dart';

class CreateCritiquePage extends StatefulWidget {
  @override
  State createState() => CreateCritiquePageState();
}

class CreateCritiquePageState extends State<CreateCritiquePage>
    implements CreateCritiqueBlocDelegate {
  final TextEditingController _critiqueController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateCritiqueBloc _createCritiqueBloc;

  double _rating = 0;

  @override
  void initState() {
    super.initState();
    _createCritiqueBloc = BlocProvider.of<CreateCritiqueBloc>(context);
    _createCritiqueBloc.setDelegate(delegate: this);
  }

  Widget _buildBottomSheetForm() {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, kToolbarHeight, 20, 0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: Theme.of(context).textTheme.headline4.color,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _critiqueController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: locator<ValidationService>().isEmpty,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline4.color,
                      ),
                      maxLines: 5,
                      maxLength: CRITIQUE_CHAR_LIMIT,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6.color),
                          counterStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6.color),
                          hintText: 'What do you think about this movie/show?',
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline4.color)),
                    ),
                  ),
                  Center(
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _rating = rating;
                      },
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text('Cancel'),
                        onPressed: () {
                          _critiqueController.clear();
                          Navigator.of(context).pop();
                        },
                        color: Colors.white,
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text('Save'),
                          onPressed: () async {
                            final bool formValid =
                                _formKey.currentState.validate();

                            if (!formValid) return;

                            final bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Submit Critique',
                                    message: 'Are you sure?');

                            if (!confirm) return;

                            Navigator.of(context).pop();

                            _createCritiqueBloc.add(
                              SubmitEvent(
                                critique: _critiqueController.text,
                                rating: _rating,
                              ),
                            );
                          },
                          color: Theme.of(context).buttonColor,
                          textColor: Colors.white,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCritiqueBloc, CreateCritiqueState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return Scaffold(
            key: _scaffoldKey,
            body: Spinner(),
          );
        }

        if (state is LoadedState) {
          final MovieModel movie = state.movie;
          final bool watchListHasMovie = state.watchListHasMovie;
          final UserModel currentUser = state.currentUser;
          final List<CritiqueModel> otherCritiques = state.otherCritiques;

          return Scaffold(
            key: _scaffoldKey,
            bottomSheet: InkWell(
              onTap: () {
                showModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return _buildBottomSheetForm();
                  },
                );
              },
              child: Container(
                color: Theme.of(context).cardColor,
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Write Critique About Movie',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              title: Text(
                movie.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                watchListHasMovie
                    ? IconButton(
                        icon: Icon(
                          Icons.bookmark,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _createCritiqueBloc.add(
                            RemoveMovieFromWatchlistEvent(),
                          );
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.bookmark_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _createCritiqueBloc.add(
                            AddMovieToWatchlistEvent(),
                          );
                        })
              ],
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          // color: Colors.black,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken),
                              image: AssetImage('assets/images/theater.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CachedNetworkImage(
                                    imageUrl: '${movie.poster}',
                                    imageBuilder: (context, imageProvider) =>
                                        Image(
                                      image: imageProvider,
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      movie.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.note,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Plot',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                movie.plot,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Director & Actors',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${movie.director} - ${movie.actors}',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Released',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                movie.released,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Icon(
                                    Icons.rate_review,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'IMDB Rating',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${movie.imdbRating}/10 (${movie.imdbVotes} votes)',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Icon(
                                    Icons.movie_sharp,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Genre',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                movie.genre,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Critiques',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: otherCritiques.length,
                            itemBuilder: (context, index) {
                              CritiqueModel otherCritique =
                                  otherCritiques[index];
                              return Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: SmallCritiqueView(
                                    critique: otherCritique,
                                    currentUser: currentUser,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
          child: Text('You should NEVER see this.'),
        );
      },
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showAlert(context: context, title: 'Success', message: message);
  }

  @override
  void clearText() {
    _critiqueController.clear();
  }
}
