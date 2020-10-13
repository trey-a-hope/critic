const functions = require('firebase-functions');
const env = functions.config();
const streamio = require('getstream');
const streamioClient = streamio.connect(env.streamio.apikey, env.streamio.appsecret, env.streamio.appid);

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