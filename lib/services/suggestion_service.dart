import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/data/suggestion_model.dart';
import 'package:get/get.dart';

class SuggestionService extends GetxService {
  final CollectionReference _suggestionsColRef =
      FirebaseFirestore.instance.collection('Suggestions');
  final CollectionReference _dataColRef =
      FirebaseFirestore.instance.collection('Data');
  Future<void> createSuggestion({required SuggestionModel suggestion}) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference suggestionDocRef = _suggestionsColRef.doc();
      Map map = suggestion.toJson();
      map['id'] = suggestionDocRef.id;

      batch.set(suggestionDocRef, map);

      final DocumentReference tableCountsDocRef =
          _dataColRef.doc('tableCounts');
      batch.update(tableCountsDocRef, {'suggestions': FieldValue.increment(1)});

      await batch.commit();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> deleteSuggestion({required String suggestionID}) {
    throw UnimplementedError();
  }

  Future<List<SuggestionModel>> listSuggestions() {
    throw UnimplementedError();
  }

  Future<SuggestionModel> readSuggestion({required String suggestionID}) {
    throw UnimplementedError();
  }

  Future<void> updateSuggestion({required SuggestionModel suggestion}) {
    throw UnimplementedError();
  }
}
