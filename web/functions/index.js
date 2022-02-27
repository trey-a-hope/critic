const functions = require('firebase-functions');
const admin = require('firebase-admin');
const MongoDBCritiques = require('./mongodb/critique_functions');
const Util = require('./util/util_functions');

admin.initializeApp(functions.config().firebase);

/// Util functions.
exports.UtilGenerateApplicationCsv = Util.generateApplicationCsv;

/// Mongo DB - Critique functions.
exports.MongoDBCritiquesGet = MongoDBCritiques.get;
exports.MongoDBCritiquesCount = MongoDBCritiques.count;
exports.MongoDBCritiquesListSimilar = MongoDBCritiques.listSimilar;
exports.MongoDBCritiquesListByUser = MongoDBCritiques.listByUser;
exports.MongoDBCritiquesListByGenre = MongoDBCritiques.listByGenre;
exports.MongoDBCritiquesList = MongoDBCritiques.list;
exports.MongoDBCritiquesCreate = MongoDBCritiques.create;
exports.MongoDBCritiquesDelete = MongoDBCritiques.delete;
exports.MongoDBCritiquesDeleteAll = MongoDBCritiques.deleteAll;
exports.MongoDBCritiquesUpdate = MongoDBCritiques.update;
exports.MongoDBCritiquesAddComment = MongoDBCritiques.addComment;
exports.MongoDBCritiquesAddLike = MongoDBCritiques.addLike;
exports.MongoDBCritiquesRemoveLike = MongoDBCritiques.removeLike;
