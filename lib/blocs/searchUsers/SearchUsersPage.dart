import 'package:critic/blocs/searchUsers/Bloc.dart' as SEARCH_USERS_BP;
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;

import 'package:critic/models/UserModel.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_SearchBar(), _SearchBody()],
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _textController = TextEditingController();
  SEARCH_USERS_BP.SearchUsersBloc _searchUsersBloc;

  @override
  void initState() {
    super.initState();
    _searchUsersBloc =
        BlocProvider.of<SEARCH_USERS_BP.SearchUsersBloc>(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        _searchUsersBloc.add(
          SEARCH_USERS_BP.TextChangedEvent(text: text),
        );
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          child: Icon(Icons.clear),
          onTap: _onClearTapped,
        ),
        border: InputBorder.none,
        hintText: 'Enter a search term',
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _searchUsersBloc.add(SEARCH_USERS_BP.TextChangedEvent(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SEARCH_USERS_BP.SearchUsersBloc,
        SEARCH_USERS_BP.SearchUsersState>(
      builder: (BuildContext context, SEARCH_USERS_BP.SearchUsersState state) {
        if (state is SEARCH_USERS_BP.SearchUsersStateStart) {
          return Expanded(
            child: Center(
              child: Text('Enter a username...'),
            ),
          );
        }

        if (state is SEARCH_USERS_BP.SearchUsersStateLoading) {
          return Spinner();
        }

        if (state is SEARCH_USERS_BP.SearchUsersStateError) {
          return Expanded(
            child: Center(
              child: Text(state.error.message),
            ),
          );
        }

        if (state is SEARCH_USERS_BP.SearchUsersStateNoResults) {
          return Expanded(
            child: Center(
              child: Text('No results found. :('),
            ),
          );
        }

        if (state is SEARCH_USERS_BP.SearchUsersStateFoundResults) {
          final List<UserModel> users = state.users;

          return Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final UserModel user = users[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.imgUrl),
                  ),
                  title: Text('${user.username}'),
                  subtitle: Text('${user.email}'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => OTHER_PROFILE_BP.OtherProfileBloc(
                          otherUserID: user.uid,
                        )..add(
                            OTHER_PROFILE_BP.LoadPageEvent(),
                          ),
                        child: OTHER_PROFILE_BP.OtherProfilePage(),
                      ),
                    );

                    Navigator.push(context, route);
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
