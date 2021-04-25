part of 'other_profile_bloc.dart';

class OtherProfilePage extends StatefulWidget {
  @override
  State createState() => OtherProfilePageState();
}

class OtherProfilePageState extends State<OtherProfilePage>
    implements OTHER_PROFILE_BP.OtherProfileBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OTHER_PROFILE_BP.OtherProfileBloc _otherProfileBloc;
  String _lastID = '';

  @override
  void initState() {
    _otherProfileBloc = BlocProvider.of<OtherProfileBloc>(context);
    _otherProfileBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileBloc, OTHER_PROFILE_BP.OtherProfileState>(
      builder:
          (BuildContext context, OTHER_PROFILE_BP.OtherProfileState state) {
        if (state is OTHER_PROFILE_BP.LoadingState) {
          return Scaffold(
            body: Spinner(),
          );
        }

        if (state is OTHER_PROFILE_BP.LoadedState) {
          final UserModel otherUser = state.otherUser;

          return Scaffold(
            key: _scaffoldKey,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: colorNavy,
                    expandedHeight: 300.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        '${otherUser.username}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                            image: AssetImage('assets/images/theater.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: '${otherUser.imgUrl}',
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 40,
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: RefreshIndicator(
                child: PaginationList<CritiqueModel>(
                  onLoading: Spinner(),
                  onPageLoading: Spinner(),
                  separatorWidget: Divider(height: 0),
                  itemBuilder: (BuildContext context, CritiqueModel critique) {
                    return CritiqueView(
                      critique: critique,
                      currentUser: otherUser,
                    );
                  },
                  pageFetch: (int offset) async {
                    List<CritiqueModel> critiques =
                        await locator<CritiqueService>().listByUser(
                      uid: otherUser.uid,
                      limit: PAGE_FETCH_LIMIT,
                      lastID: _lastID,
                    );

                    if (critiques.isEmpty) return critiques;

                    _lastID = critiques[0].id;

                    return critiques;
                  },
                  onError: (dynamic error) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          'Error',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  onEmpty: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.movieEdit,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          '$MESSAGE_EMPTY_CRITIQUES',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ),
                onRefresh: () {
                  _otherProfileBloc.add(
                    OTHER_PROFILE_BP.LoadPageEvent(),
                  );

                  return;
                },
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }

  @override
  void navigateHome() {
    Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );
  }
}
