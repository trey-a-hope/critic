import 'package:critic/blocs/home/Bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/SmallCritiqueView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ServiceLocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pagination/pagination.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> implements HomeBlocDelegate {
  HomeBloc _homeBloc;

  final GlobalKey keyButton = GlobalKey();

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

  Future<List<CritiqueModel>> pageFetch(int offset) async {
    //Fetch template documents.
    List<CritiqueModel> critiques =
        await locator<CritiqueService>().retrieveCritiquesFromStream(
      limit: _homeBloc.limit,
      offset: offset,
      uid: _homeBloc.currentUser.uid,
    );

    return critiques;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        if (state is LoadingState) {
          return Spinner();
        }

        if (state is LoadedState) {
          final UserModel currentUser = state.currentUser;
          return RefreshIndicator(
            child: PaginationList<CritiqueModel>(
              onLoading: Spinner(),
              onPageLoading: Spinner(),
              separatorWidget: Divider(),
              itemBuilder: (BuildContext context, CritiqueModel critique) {
                return SmallCritiqueView(
                  critique: critique,
                  currentUser: currentUser,
                );
              },
              pageFetch: pageFetch,
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
                      'No critiques at this moment.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Create your own or follow someone.')
                  ],
                ),
              ),
            ),
            onRefresh: () {
              _homeBloc.add(
                LoadPageEvent(),
              );

              return;
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
  void showMessage({
    @required String title,
    @required String body,
  }) {
    locator<ModalService>().showAlert(
      context: context,
      title: title,
      message: body,
    );
  }
}
