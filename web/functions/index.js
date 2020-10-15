const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Algolia = require('./algolia/index');
const StreamIO = require('./streamio/index');

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