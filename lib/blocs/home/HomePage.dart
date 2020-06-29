import 'package:critic/blocs/home/Bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/widgets/CritiqueView.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HomeBloc _homeBloc;
  // StreamController<List<DocumentSnapshot>> streamController =
  //     StreamController<List<DocumentSnapshot>>();
  // List<DocumentSnapshot> critiques = [];

  // bool isRequesting = false;
  // bool isFinish = false;
  // final int limit = 10;

  // void onChangeData(List<DocumentChange> documentChanges) {
  //   var isChange = false;
  //   documentChanges.forEach((critiqueChange) {
  //     if (critiqueChange.type == DocumentChangeType.removed) {
  //       critiques.removeWhere((critique) {
  //         return critiqueChange.document.documentID == critique.documentID;
  //       });
  //       isChange = true;
  //     } else {
  //       if (critiqueChange.type == DocumentChangeType.modified) {
  //         int indexWhere = critiques.indexWhere((product) {
  //           return critiqueChange.document.documentID == product.documentID;
  //         });

  //         if (indexWhere >= 0) {
  //           critiques[indexWhere] = critiqueChange.document;
  //         }
  //         isChange = true;
  //       }
  //     }
  //   });

  //   if (isChange) {
  //     streamController.add(critiques);
  //   }
  // }

  @override
  void initState() {
    // Firestore.instance
    //     .collection('Critiques')
    //     .snapshots()
    //     .listen((data) => onChangeData(data.documentChanges));

    // requestNextPage();
    _homeBloc = BlocProvider.of<HomeBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    // streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        if (state is LoadingState) {
          return Spinner();
        }

        if (state is LoadedState) {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.maxScrollExtent ==
                  scrollInfo.metrics.pixels) {
                _homeBloc.add(
                  RequestNextPageEvent(),
                );
              }
              return true;
            },
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
              itemCount: state.docs.length,
              itemBuilder: (BuildContext context, int index) {
                CritiqueModel critique =
                    CritiqueModel.extractDocument(ds: state.docs[index]);
                return CritiqueView(
                  critique: critique,
                );
              },
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

  // void requestNextPage() async {
  //   if (!isRequesting && !isFinish) {
  //     QuerySnapshot querySnapshot;
  //     isRequesting = true;
  //     if (critiques.isEmpty) {
  //       querySnapshot = await Firestore.instance
  //           .collection('Critiques')
  //           .orderBy('created', descending: true)
  //           .limit(limit)
  //           .getDocuments();
  //     } else {
  //       querySnapshot = await Firestore.instance
  //           .collection('Critiques')
  //           .orderBy('created', descending: true)
  //           .startAfterDocument(critiques[critiques.length - 1])
  //           .limit(limit)
  //           .getDocuments();
  //     }

  //     if (querySnapshot != null) {
  //       int oldSize = critiques.length;
  //       critiques.addAll(querySnapshot.documents);
  //       int newSize = critiques.length;
  //       if (oldSize != newSize) {
  //         streamController.add(critiques);
  //       } else {
  //         isFinish = true;
  //       }
  //     }
  //     isRequesting = false;
  //   }
  // }
}
