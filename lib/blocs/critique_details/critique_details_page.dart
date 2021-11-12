part of 'critique_details_bloc.dart';

class CritiqueDetailsPage extends StatefulWidget {
  @override
  State createState() => CritiqueDetailsPageState();
}

class CritiqueDetailsPageState extends State<CritiqueDetailsPage>
    implements CritiqueDetailsBlocDelegate {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    context.read<CritiqueDetailsBloc>().setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildTitle({
    required String title,
  }) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        '$title',
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CritiqueDetailsBloc, CritiqueDetailsState>(
      builder: (BuildContext context, CritiqueDetailsState state) {
        if (state is LoadingState) {
          return Scaffold(
            appBar: AppBar(),
            body: Spinner(),
          );
        }

        if (state is LoadedState) {
          final CritiqueModel critique = state.critiqueModel;
          final UserModel currentUser = state.currentUser;
          final UserModel critiqueUser = state.critiqueUser;
          final bool isLiked = state.isLiked;
          final List<UserModel> likedUsers = state.likedUsers;
          final List<CritiqueModel> otherCritiques = state.otherCritiques;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('${critiqueUser.username} says...'),
              actions: [
                if (currentUser.uid == critique.uid) ...[
                  IconButton(
                    onPressed: () async {
                      final bool? confirm = await locator<ModalService>()
                          .showConfirmation(
                              context: context,
                              title: 'Delete Critique',
                              message: 'Are you sure?');

                      if (confirm == null || !confirm) return;

                      context.read<CritiqueDetailsBloc>().add(
                            DeleteCritiqueEvent(),
                          );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
                if (currentUser.uid != critique.uid) ...[
                  IconButton(
                    onPressed: () async {
                      bool? confirm = await locator<ModalService>()
                          .showConfirmation(
                              context: context,
                              title: 'Report Critique',
                              message:
                                  'If this material was abusive, disrespectful, or uncomfortable, let us know please. This post will become flagged and removed from your timeline.');

                      if (confirm == null || !confirm) return;

                      context.read<CritiqueDetailsBloc>().add(
                            ReportCritiqueEvent(),
                          );
                    },
                    icon: Icon(
                      Icons.report,
                      color: Colors.red,
                    ),
                  )
                ],
                IconButton(
                  onPressed: () {
                    if (isLiked) {
                      context.read<CritiqueDetailsBloc>().add(
                            UnlikeCritiqueEvent(),
                          );
                    } else {
                      context.read<CritiqueDetailsBloc>().add(
                            LikeCritiqueEvent(),
                          );
                    }
                  },
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: ListView(
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    margin: EdgeInsets.only(bottom: 20.0),
                    height: 300,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              locator<UtilService>().heroToImage(
                                context: context,
                                imgUrl: '${critique.movie!.poster}',
                                tag: critique.movie!.title,
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: '${critique.movie!.poster}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(5.0, 5.0),
                                        blurRadius: 10.0)
                                  ],
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SelectableText(
                                  '\"${critique.message}\"',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                Spacer(),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.red.shade900),
                                    textStyle: MaterialStateProperty.all(
                                      TextStyle(color: Colors.white),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  child: Text('View Details'),
                                  onPressed: () {
                                    Route route = MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => CREATE_CRITIQUE_BP
                                            .CreateCritiqueBloc(
                                          movie: critique.movie!,
                                        )..add(
                                            CREATE_CRITIQUE_BP.LoadPageEvent(),
                                          ),
                                        child: CREATE_CRITIQUE_BP
                                            .CreateCritiquePage(),
                                      ),
                                    );

                                    Navigator.push(context, route);
                                  },
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              color: Theme.of(context).canvasColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(5.0, 5.0),
                                    blurRadius: 10.0)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    leading: InkWell(
                      onTap: () async {
                        if (critiqueUser.uid == currentUser.uid) return;

                        Route route = MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                OTHER_PROFILE_BP.OtherProfileBloc(
                              otherUserID: '${critiqueUser.uid}',
                            )..add(
                                    OTHER_PROFILE_BP.LoadPageEvent(),
                                  ),
                            child: OTHER_PROFILE_BP.OtherProfilePage(),
                          ),
                        );

                        Navigator.push(context, route);
                      },
                      child: CachedNetworkImage(
                        imageUrl: '${critiqueUser.imgUrl}',
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    title: Text('${critiqueUser.username}',
                        style: Theme.of(context).textTheme.headline4),
                    subtitle: Text(
                        '${timeago.format(critique.created, allowFromNow: true)} on ${DateFormat('MMM dd, yyyy').format(critique.created)}',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  Divider(),
                  _buildTitle(title: 'Likes'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Route route = MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LikesPage(likedUsers: likedUsers),
                          );

                          Navigator.push(context, route);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 50,
                          ),
                          child: ImageStack(
                            imageList: likedUsers
                                .map((likedUser) => likedUser.imgUrl)
                                .toList(),
                            showTotalCount: true,
                            totalCount: likedUsers.length,
                            imageRadius: 30,
                            imageCount: 3,
                            imageBorderWidth: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  _buildTitle(title: 'Rating'),
                  Center(
                    child: RatingBarIndicator(
                      rating: critique.rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 50.0,
                      direction: Axis.horizontal,
                    ),
                  ),
                  Divider(),
                  _buildTitle(title: 'Comments'),
                  for (int i = 0; i < critique.comments.length; i++) ...[
                    ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: '${critique.comments[i].user!.imgUrl}',
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      title: Text(
                        '\"${critique.comments[i].comment}\"',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                        '${critique.comments[i].user!.username}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      trailing: Text(
                        '${timeago.format(critique.comments[i].created!, allowFromNow: true)}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )
                  ],
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: Theme.of(context).textTheme.headline4!.color,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _commentController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: locator<ValidationService>().isEmpty,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline4!.color,
                      ),
                      maxLines: 5,
                      maxLength: CRITIQUE_CHAR_LIMIT,
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6!.color),
                          counterStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6!.color),
                          hintText:
                              'Leave a comment about ${critiqueUser.username}\'s critique...',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .color)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red.shade900),
                        textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.white),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Text('Post Comment'),
                      onPressed: () async {
                        final bool? confirm = await locator<ModalService>()
                            .showConfirmation(
                                context: context,
                                title: 'Post Comment',
                                message: 'Are you sure?');

                        if (confirm == null || !confirm) return;

                        context.read<CritiqueDetailsBloc>().add(
                              PostCommentEvent(
                                  comment: _commentController.text),
                            );
                      },
                    ),
                  ),
                  Divider(),
                  _buildTitle(title: 'Other Critiques'),
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: otherCritiques.length,
                      itemBuilder: (context, index) {
                        CritiqueModel otherCritique = otherCritiques[index];
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
                  SizedBox(height: 10),
                  Divider(),
                ],
              ),
            ),
          );
        }

        if (state is ErrorState) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Error'),
            ),
            body: Center(
              child: Text(
                '${state.error.toString()}',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  @override
  void showMessage({
    required String title,
    required String message,
  }) {
    locator<ModalService>().showAlert(
      context: context,
      title: '$title',
      message: '$message',
    );
  }

  @override
  void clearText() {
    _commentController.clear();
  }

  @override
  void pop() {
    Navigator.of(context).pop();
  }
}
