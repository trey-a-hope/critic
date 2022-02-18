import 'package:critic/constants.dart';
import 'package:critic/models/data/comment_model.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class CritiqueService extends GetxService {
  Future<CritiqueModel> get({required String id}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesGet'),
        body: json.encode({
          'id': id,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final dynamic result = json.decode(response.body);

      CritiqueModel critique = CritiqueModel.fromJson(result);

      return critique;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<List<CritiqueModel>> listByUser({
    required String uid,
    required int limit,
    String? lastID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesListByUser'),
        body: json.encode({
          'uid': uid,
          'limit': limit,
          'last_id': lastID,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final List<dynamic> results = json.decode(response.body) as List<dynamic>;

      List<CritiqueModel> critiques = results
          .map(
            (result) => CritiqueModel.fromJson(result),
          )
          .toList();

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<List<CritiqueModel>> listByGenre({
    required String genre,
    required int limit,
    String? lastID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesListByGenre'),
        body: json.encode({
          'genre': genre,
          'limit': limit,
          'last_id': lastID,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final List<dynamic> results = json.decode(response.body) as List<dynamic>;

      List<CritiqueModel> critiques = results
          .map(
            (result) => CritiqueModel.fromJson(result),
          )
          .toList();

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> create({required CritiqueModel critique}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesCreate'),
        body: json.encode(critique.toJson()),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> delete({required String id}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesDelete'),
        body: json.encode({'id': id}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> update(
      {required String id, required Map<String, dynamic> params}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesUpdate'),
        body: json.encode({'id': id, 'params': params}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> addComment(
      {required String id, required CommentModel comment}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesAddComment'),
        body: json.encode({'id': id, 'comment': comment.toJson()}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> addLike({
    required String id,
    required String uid,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesAddLike'),
        body: json.encode({'id': id, 'uid': uid}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<List<CritiqueModel>> listSimilar({
    String? id,
    required String imdbID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesListSimilar'),
        body: json.encode({
          'id': id,
          'imdbID': imdbID,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final List<dynamic> results = json.decode(response.body) as List<dynamic>;

      List<CritiqueModel> critiques = results
          .map(
            (result) => CritiqueModel.fromJson(result),
          )
          .toList();

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> removeLike({
    required String id,
    required String uid,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesRemoveLike'),
        body: json.encode({'id': id, 'uid': uid}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<int> count({required String uid}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesCount'),
        body: json.encode({'uid': uid}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return 0;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> deleteAll() async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesDeleteAll'),
        //body: json.encode({'id': id}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<List<CritiqueModel>> list({
    required int limit,
    String? lastID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesList'),
        body: json.encode({
          'limit': limit,
          'last_id': lastID,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final List<dynamic> results = json.decode(response.body) as List<dynamic>;

      List<CritiqueModel> critiques = results
          .map(
            (result) => CritiqueModel.fromJson(result),
          )
          .toList();

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
