const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Algolia = require('./algolia/index');
const StreamIO = require('./streamio/index');

admin.initializeApp(functions.config().firebase);

//Algolia
exports.AlgoliaSyncUsers = Algolia.algoliaSyncUsers;

//StreamIO
exports.AddCritiqueToFeed = StreamIO.addCritiqueToFeed;
exports.GetUserFeed = StreamIO.getUserFeed;
