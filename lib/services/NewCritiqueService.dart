import 'package:critic/Constants.dart';
import 'package:critic/models/NewCritiqueModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

abstract class INewCritiqueService {
  Future<List<NewCritiqueModel>> getCritiques({
    @required String uid,
  });
}

class NewCritiqueService extends INewCritiqueService {
  @override
  Future<List<NewCritiqueModel>> getCritiques({@required String uid}) async {
    try {
      Map data = {
        'uid': uid,
        // 'limit': '$limit',
        // 'offset': '$offset',
      };

      http.Response response = await http.get(
        '${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesGet',
        //body: {},
        headers: {'content-type': 'application/x-www-form-urlencoded'},
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
}
