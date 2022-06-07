import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/data/recipe_model.dart';

class FirestoreService extends GetxService {
  /// Instance of FirebaseFirestore
  static FirebaseFirestore instance = FirebaseFirestore.instance;

  /// The 'feelings' collection table.
  final CollectionReference _recipesCollection =
  instance.collection('Recipe');


  /// Returns a collection reference specified the collection title.
  CollectionReference? _collectionReference({required String collection}) {
    switch (collection) {
      case 'Recipe':
        return  _recipesCollection;
      default:
        return null;
    }
  }

  /// Create document.
  Future<void> createDocument({
    required String collection,
    required Map data,
    String? documentID,
  }) async {
    try {
      // Create document reference.
      DocumentReference documentReference;
      if (documentID == null) {
        documentReference = _collectionReference(collection: collection)!.doc();
        data['id'] = documentReference.id;
      } else {
        documentReference =
            _collectionReference(collection: collection)!.doc(documentID);
      }

      // Assign doc ref with user data.
      documentReference.set(data);

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  /// Update document.
  Future<void> updateDocument({
    required String collection,
    required Map<String, Object?> data,
    required documentID,
  }) async {
    try {
      // Fetch document reference.Ï
      DocumentReference documentReference =
      _collectionReference(collection: collection)!.doc(documentID);

      // Update data for this document.
      documentReference.update(data);

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  /// Retrieve document.
  Future<DocumentSnapshot?> retrieveDocument({
    required String collection,
    required String documentId,
  }) async {
    try {
      switch (collection) {
        case 'Recipe':
          return (await _recipesCollection.doc(documentId)
              .withConverter<RecipeModel>(
              fromFirestore: (snapshot, _) =>
                  RecipeModel.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson())
              .get());
        default:
          return null;
      }
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  /// Retrieve documents.
  Future<List<QueryDocumentSnapshot>?> retrieveDocuments({
    required String collection,
  }) async {
    try {
      switch (collection) {
        case 'Recipe':
          return (await _recipesCollection
              .withConverter<RecipeModel>(
              fromFirestore: (snapshot, _) =>
                  RecipeModel.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson())
              // .orderBy('created', descending: true)
              .get())
              .docs;
        default:
          return null;
      }
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}