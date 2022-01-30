import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/data/suggestion_model.dart';

abstract class ISuggestionService {
  Future<void> createSuggestion({required SuggestionModel suggestion});
  Future<SuggestionModel> readSuggestion({required String suggestionID});
  Future<List<SuggestionModel>> listSuggestions();
  Future<void> updateSuggestion({required SuggestionModel suggestion});
  Future<void> deleteSuggestion({required String suggestionID});
}

class SuggestionService extends ISuggestionService {
  final CollectionReference _suggestionsColRef =
      FirebaseFirestore.instance.collection('Suggestions');
  final CollectionReference _dataColRef =
      FirebaseFirestore.instance.collection('Data');
  @override
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

  @override
  Future<void> deleteSuggestion({required String suggestionID}) {
    throw UnimplementedError();
  }

  @override
  Future<List<SuggestionModel>> listSuggestions() {
    throw UnimplementedError();
  }

  @override
  Future<SuggestionModel> readSuggestion({required String suggestionID}) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateSuggestion({required SuggestionModel suggestion}) {
    throw UnimplementedError();
  }
}
