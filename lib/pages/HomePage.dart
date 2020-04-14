import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/widgets/CritiqueView.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GetIt getIt = GetIt.I;
  StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> critiques = [];

  bool isRequesting = false;
  bool isFinish = false;
  final int limit = 5;

  void onChangeData(List<DocumentChange> documentChanges) {
    var isChange = false;
    documentChanges.forEach((critiqueChange) {
      if (critiqueChange.type == DocumentChangeType.removed) {
        critiques.removeWhere((critique) {
          return critiqueChange.document.documentID == critique.documentID;
        });
        isChange = true;
      } else {
        if (critiqueChange.type == DocumentChangeType.modified) {
          int indexWhere = critiques.indexWhere((product) {
            return critiqueChange.document.documentID == product.documentID;
          });

          if (indexWhere >= 0) {
            critiques[indexWhere] = critiqueChange.document;
          }
          isChange = true;
        }
      }
    });

    if (isChange) {
      streamController.add(critiques);
    }
  }

  @override
  void initState() {
    Firestore.instance
        .collection('Critiques')
        .snapshots()
        .listen((data) => onChangeData(data.documentChanges));

    requestNextPage();
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
            requestNextPage();
          }
          return true;
        },
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: streamController.stream,
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                List<DocumentSnapshot> critiqueDocs = snapshot.data;
                //log("Items: " + snapshot.data.length.toString());
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemCount: critiqueDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    CritiqueModel critique =
                        CritiqueModel.extractDocument(ds: critiqueDocs[index]);
                    return CritiqueView(
                      critique: critique,
                    );
                  },
                );
            }
          },
        ));
  }

  void requestNextPage() async {
    if (!isRequesting && !isFinish) {
      QuerySnapshot querySnapshot;
      isRequesting = true;
      if (critiques.isEmpty) {
        querySnapshot = await Firestore.instance
            .collection('Critiques')
            .orderBy('created')
            .limit(limit)
            .getDocuments();
      } else {
        querySnapshot = await Firestore.instance
            .collection('Critiques')
            .orderBy('created')
            .startAfterDocument(critiques[critiques.length - 1])
            .limit(limit)
            .getDocuments();
      }

      if (querySnapshot != null) {
        int oldSize = critiques.length;
        critiques.addAll(querySnapshot.documents);
        int newSize = critiques.length;
        if (oldSize != newSize) {
          streamController.add(critiques);
        } else {
          isFinish = true;
        }
      }
      isRequesting = false;
    }
  }
}
