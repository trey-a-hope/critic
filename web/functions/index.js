const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Algolia = require('./algolia/index');
const StreamIO = require('./streamio/index');

admin.initializeApp(functions.config().firebase);

//Algolia
exports.AlgoliaSyncUsers = Algolia.algoliaSyncUsers;

//StreamIO
exports.AddActivityToFeed = StreamIO.addActivityToFeed;
exports.GetUserFeed = StreamIO.getUserFeed;
