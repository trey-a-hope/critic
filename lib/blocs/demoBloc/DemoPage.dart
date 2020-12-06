import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/services/ModalService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc.dart';

class DemoPage extends StatefulWidget {
  @override
  State createState() => DemoPageState();
}

class DemoPageState extends State<DemoPage> implements DemoBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DemoBloc _demoBloc;

  @override
  void initState() {
    _demoBloc = BlocProvider.of<DemoBloc>(context);
    _demoBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: COLOR_NAVY,
        title: Text(
          'Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DemoBloc, DemoState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return null;
          }

          if (state is LoadedState) {
            return null;
          }

          return Center(
            child: Text('You should NEVER see this.'),
          );
        },
      ),
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
