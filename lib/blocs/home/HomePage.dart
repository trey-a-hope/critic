import 'package:critic/blocs/home/Bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/CritiqueView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ServiceLocator.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> implements HomeBlocDelegate {
  HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        if (state is LoadingState) {
          return Spinner();
        }

        if (state is NoCritiquesState) {
          return Center(
            child: Text('None of your followees have critiqued.'),
          );
        }

        if (state is FoundCritiquesState) {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemCount: state.critiques.length,
            itemBuilder: (BuildContext context, int index) {
              CritiqueModel critique = state.critiques[index];
              return CritiqueView(
                critique: critique,
              );
            },
          );
        }

        if (state is ErrorState) {
          return Center(
            child: Text('Error: ${state.error.toString()}'),
          );
        }
        return Container();
      },
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>()
        .showAlert(context: context, title: '', message: message);
  }
}
