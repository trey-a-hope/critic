const functions = require('firebase-functions');
const algoliasearch = require('algoliasearch');
const algoliaSync = require('algolia-firestore-sync');

const env = functions.config()
const client = algoliasearch(env.algolia.appid, env.algolia.apikey)
const index = client.initIndex('Users');

exports.algoliaSyncUsers = functions.firestore
    .document('Users/{id}')
    .onWrite((change, context) => {
        return algoliaSync.syncAlgoliaWithFirestore(index, change, context);
    });
