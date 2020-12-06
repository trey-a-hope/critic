import 'package:critic/ServiceLocator.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc.dart';

class WatchlistPage extends StatefulWidget {
  @override
  State createState() => WatchlistPageState();
}

class WatchlistPageState extends State<WatchlistPage>
    implements WatchlistBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  WatchlistBloc _watchlistBloc;

  @override
  void initState() {
    _watchlistBloc = BlocProvider.of<WatchlistBloc>(context);
    _watchlistBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return Spinner();
        }

        if (state is LoadedState) {
          return Center(
            child: Text('Watch List Page'),
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
    @required String message,
  }) {
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }
}
