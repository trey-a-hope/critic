part of 'search_users_bloc.dart';

class SearchUsersPage extends StatelessWidget {
  final bool returnUser;

  SearchUsersPage({required this.returnUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Column(
        children: <Widget>[_SearchBar(), _SearchBody(returnUser: returnUser)],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Theme.of(context).textTheme.headline6!.color),
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        context.read<SearchUsersBloc>().add(
              TextChangedEvent(text: text),
            );
      },
      cursorColor: Theme.of(context).textTheme.headline5!.color,
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).iconTheme.color,
        ),
        suffixIcon: GestureDetector(
          child: Icon(
            Icons.clear,
            color: Theme.of(context).iconTheme.color,
          ),
          onTap: _onClearTapped,
        ),
        border: InputBorder.none,
        hintText: 'Enter a search term',
        hintStyle:
            TextStyle(color: Theme.of(context).textTheme.headline6!.color),
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    context.read<SearchUsersBloc>().add(TextChangedEvent(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  final bool returnUser;

  _SearchBody({required this.returnUser});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchUsersBloc, SearchUsersState>(
      builder: (BuildContext context, SearchUsersState state) {
        if (state is SearchUsersStateStart) {
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 100,
                ),
                Text('Please enter a username...',
                    style: Theme.of(context).textTheme.headline6),
              ],
            ),
          );
        }

        if (state is SearchUsersStateLoading) {
          return Spinner();
        }

        if (state is SearchUsersStateError) {
          return Expanded(
            child: Center(
              child: Text(state.error.message),
            ),
          );
        }

        if (state is SearchUsersStateNoResults) {
          return Expanded(
            child: Center(
              child: Text('No results found. :('),
            ),
          );
        }

        if (state is SearchUsersStateFoundResults) {
          final List<UserModel> users = state.users;

          return Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final UserModel user = users[index];
                // return UserListTile(user: user);

                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: '${user.imgUrl}',
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(
                    '${user.username}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    '${user.email}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => OTHER_PROFILE_BP.OtherProfileBloc(
                          otherUserID: user.uid!,
                        )..add(
                            OTHER_PROFILE_BP.LoadPageEvent(),
                          ),
                        child: OTHER_PROFILE_BP.OtherProfilePage(),
                      ),
                    );

                    if (returnUser) {
                      Navigator.pop(context, user);
                    } else {
                      Navigator.push(context, route);
                    }
                  },
                );
              },
            ),
          );
        }

        return Center(
          child: Text('YOU SHOULD NEVER SEE THIS...'),
        );
      },
    );
  }
}
