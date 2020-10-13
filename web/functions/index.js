const functions = require('firebase-functions');
const algoliasearch = require('algoliasearch');
const algoliaSync = require('algolia-firestore-sync');
const streamio = require('getstream');

const env = functions.config();
const client = algoliasearch(env.algolia.appid, env.algolia.apikey);
const streamioClient = streamio.connect(env.streamio.apikey, env.streamio.appsecret, env.appid);
const index = client.initIndex('Users');

exports.algoliaSyncUsers = functions.firestore
    .document('Users/{id}')
    .onWrite((change, context) => {
        return algoliaSync.syncAlgoliaWithFirestore(index, change, context);
    });

exports.addActivityToFeed = functions.https.onRequest((req, res) => {
    const actor = req.body.actor;
    const tweet = req.body.tweet;

    const ericFeed = streamioClient.feed('Critiques', 'TreyHope');

    ericFeed.addActivity({
        actor: actor,
        tweet: tweet,
        verb: 'tweet',
        object: 1,
        movieTitle: 'Titanic',
        uid: 'UIDXXXHERE'
    }).then((result) => {
        console.log(result);
        return res.send(result);
    }).catch((error) => {
        console.log(error);
        return res.send(error);
    });
});

exports.getUserFeed = functions.https.onRequest((req, res) => {
    //const couponID = req.body.couponID;

    const ericFeed = streamioClient.feed('Critiques', 'TreyHope');

    ericFeed.get({ limit: 10 }).then((results) => {
        console.log(results);
        return res.send(results);
    }).catch((error) => {
        console.log(error);
        return res.send(error);
    });
});
//exports.followUser
//exports.unfollowUser
//exports.getFollowers
//exports.getFollowees