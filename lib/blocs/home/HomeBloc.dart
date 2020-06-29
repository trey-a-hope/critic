import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> critiques = [];

  bool isRequesting = false;
  bool isFinish = false;
  final int limit = 10;

  @override
  HomeState get initialState => HomeState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      Firestore.instance.collection('Critiques').snapshots().listen(
            (data) => (List<DocumentChange> documentChanges) {
              bool isChange = false;
              documentChanges.forEach(
                (critiqueChange) {
                  if (critiqueChange.type == DocumentChangeType.removed) {
                    critiques.removeWhere(
                      (critique) {
                        return critiqueChange.document.documentID ==
                            critique.documentID;
                      },
                    );
                    isChange = true;
                  } else {
                    if (critiqueChange.type == DocumentChangeType.modified) {
                      int indexWhere = critiques.indexWhere(
                        (product) {
                          return critiqueChange.document.documentID ==
                              product.documentID;
                        },
                      );

                      if (indexWhere >= 0) {
                        critiques[indexWhere] = critiqueChange.document;
                      }
                      isChange = true;
                    }
                  }
                },
              );

              if (isChange) {
                streamController.add(critiques);
                add(AddCritiqueEvent());
              }
            },
          );

      requestNextPage();
    }

    if (event is AddCritiqueEvent) {
      yield LoadedState(
        docs: critiques,
      );
    }

    if (event is RequestNextPageEvent) {
      requestNextPage();
    }
  }

  void requestNextPage() async {
    if (!isRequesting && !isFinish) {
      QuerySnapshot querySnapshot;
      isRequesting = true;
      if (critiques.isEmpty) {
        querySnapshot = await Firestore.instance
            .collection('Critiques')
            .orderBy('created', descending: true)
            .limit(limit)
            .getDocuments();
      } else {
        querySnapshot = await Firestore.instance
            .collection('Critiques')
            .orderBy('created', descending: true)
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
          add(AddCritiqueEvent());
        } else {
          isFinish = true;
        }
      }
      isRequesting = false;
    }
  }

  @override
  Future<void> close() {
    // _tickerSubscription?.cancel();
    return super.close();
  }
}
