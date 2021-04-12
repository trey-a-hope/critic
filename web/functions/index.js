const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Algolia = require('./algolia/index');
const StreamIO = require('./streamio/index');
const MongoDBCritiques = require('./mongodb/critique_functions');

admin.initializeApp(functions.config().firebase);

//Algolia
exports.AlgoliaSyncUsers = Algolia.algoliaSyncUsers;

//StreamIO
exports.AddCritiqueToFeed = StreamIO.addCritiqueToFeed;
exports.DeleteCritiqueFromFeed = StreamIO.deleteCritiqueFromFeed;
exports.GetUserFeed = StreamIO.getUserFeed;
exports.FollowUserFeed = StreamIO.followUserFeed;
exports.UnfollowUserFeed = StreamIO.unfollowUserFeed;
exports.GetUsersFollowers = StreamIO.getUsersFollowers;
exports.GetUsersFollowees = StreamIO.getUsersFollowees;
exports.GetFollowStats = StreamIO.getFollowStats;
exports.IsFollowing = StreamIO.isFollowing;

//Mongo DB: Critiques
exports.MongoDBCritiquesGet = MongoDBCritiques.get;
exports.MongoDBCritiquesCount = MongoDBCritiques.count;
exports.MongoDBCritiquesListSimilar = MongoDBCritiques.listSimilar;
exports.MongoDBCritiquesListByUser = MongoDBCritiques.listByUser;
exports.MongoDBCritiquesListByGenre = MongoDBCritiques.listByGenre;
exports.MongoDBCritiquesCreate = MongoDBCritiques.create;
exports.MongoDBCritiquesDelete = MongoDBCritiques.delete;
exports.MongoDBCritiquesUpdate = MongoDBCritiques.update;
exports.MongoDBCritiquesAddComment = MongoDBCritiques.addComment;
exports.MongoDBCritiquesAddLike = MongoDBCritiques.addLike;
exports.MongoDBCritiquesRemoveLike = MongoDBCritiques.removeLike;