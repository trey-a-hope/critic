import 'package:critic/Constants.dart';
import 'package:critic/models/NewCritiqueModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

abstract class INewCritiqueService {
  Future<List<NewCritiqueModel>> list({
    @required String uid,
  });

  Future<void> create({
    @required NewCritiqueModel critique,
  });
}

class NewCritiqueService extends INewCritiqueService {
  @override
  Future<List<NewCritiqueModel>> list({@required String uid}) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesList',
        body: json.encode({'uid': uid}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final List<dynamic> results = json.decode(response.body) as List<dynamic>;

      List<NewCritiqueModel> critiques = results
          .map(
            (result) => NewCritiqueModel.fromJSON(map: result),
          )
          .toList();

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> create({@required NewCritiqueModel critique}) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesCreate',
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
}
