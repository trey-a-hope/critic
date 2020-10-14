import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/CritiqueView.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class CritiqueDetailsPage extends StatefulWidget {
  @override
  State createState() => CritiqueDetailsPageState();
}

class CritiqueDetailsPageState extends State<CritiqueDetailsPage>
    implements CritiqueDetailsBlocDelegate {
  CritiqueDetailsBloc _critiqueDetailsBloc;

  @override
  void initState() {
    _critiqueDetailsBloc = BlocProvider.of<CritiqueDetailsBloc>(context);
    _critiqueDetailsBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

          return Scaffold(
            appBar: AppBar(
              title: Text('${critique.movieTitle}'),
            ),
            body: Column(
              children: [
                FullWidthButton(
                  buttonColor: Colors.red,
                  textColor: Colors.white,
                  text: 'Delete',
                  onPressed: () {},
                )
              ],
            ),
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
