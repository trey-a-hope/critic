const functions = require('firebase-functions');
const env = functions.config();
const streamio = require('getstream');
const streamioClient = streamio.connect(env.streamio.apikey, env.streamio.apisecret, env.streamio.appid);

exports.addCritiqueToFeed = functions.https.onRequest(async (req, res) => {
    const actor = req.body.actor;
    const message = req.body.message;
    const uid = req.body.uid;
    const movieTitle = req.body.movieTitle;
    const moviePoster = req.body.moviePoster;
    const movieYear = req.body.movieYear;
    const moviePlot = req.body.moviePlot;
    const movieDirector = req.body.movieDirector;
    const imdbID = req.body.imdbID;
    const imdbRating = req.body.imdbRating;
    const imdbVotes = req.body.imdbVotes;

    const userFeed = streamioClient.feed('Critiques', uid);

    const activityResult = await userFeed.addActivity({
        actor: actor,
        verb: 'post',
        object: 1,
        message: message,
        movieTitle: movieTitle,
        modifiedDate: new Date(),
        imdbID: imdbID,
        safe: true,
        uid: uid,
        moviePoster: moviePoster,
        movieYear: movieYear,
        moviePlot: moviePlot,
        movieDirector: movieDirector,
        imdbRating: imdbRating,
        imdbVotes: imdbVotes,
    });

    try {
        return res.send(activityResult);
    } catch (error) {
        return res.send(error);
    }
});

exports.getUserFeed = functions.https.onRequest(async (req, res) => {
    const uid = req.body.uid;
    const limit = req.body.limit;
    const offset = req.body.offset;

    const userFeed = streamioClient.feed('Critiques', uid);

    const feedAPIResponse = await userFeed.get({ limit: limit, offset: offset });

    try {
        return res.send(feedAPIResponse);
    } catch (error) {
        return res.send(error);
    }
});

exports.deleteCritiqueFromFeed = functions.https.onRequest(async (req, res) => {
    const uid = req.body.uid;
    const critiqueID = req.body.critiqueID;

    const userFeed = streamioClient.feed('Critiques', uid);

    const apiResponse = await userFeed.removeActivity(critiqueID)

    try {
        return res.send(apiResponse);
    } catch (error) {
        return res.send(error);
    }
});


exports.followUserFeed = functions.https.onRequest(async (req, res) => {
    const myUID = req.body.myUID;
    const theirUID = req.body.theirUID;

    const myUserFeed = streamioClient.feed('Critiques', myUID);

    const apiResponse = await myUserFeed.follow('Critiques', theirUID);

    try {
        return res.send(apiResponse);
    } catch (error) {
        return res.send(error);
    }
});

exports.unfollowUserFeed = functions.https.onRequest(async (req, res) => {
    const myUID = req.body.myUID;
    const theirUID = req.body.theirUID;

    const myUserFeed = streamioClient.feed('Critiques', myUID);

    const apiResponse = await myUserFeed.unfollow('Critiques', theirUID);

    try {
        return res.send(apiResponse);
    } catch (error) {
        return res.send(error);
    }
});

exports.getUsersFollowers = functions.https.onRequest(async (req, res) => {
    const uid = req.body.uid;
    const limit = req.body.limit;
    const offset = req.body.offset;

    const userFeed = streamioClient.feed('Critiques', uid);

    const getFollowAPIResponse = await userFeed.followers({ limit: limit, offset: offset });

    try {
        return res.send(getFollowAPIResponse);
    } catch (error) {
        return res.send(error);
    }
});


exports.getUsersFollowees = functions.https.onRequest(async (req, res) => {
    const uid = req.body.uid;
    const limit = req.body.limit;
    const offset = req.body.offset;

    const userFeed = streamioClient.feed('Critiques', uid);

    const getFollowAPIResponse = await userFeed.following({ limit: limit, offset: offset });

    try {
        return res.send(getFollowAPIResponse);
    } catch (error) {
        return res.send(error);
    }
});

exports.getFollowStats = functions.https.onRequest(async (req, res) => {
    const uid = req.body.myUID;

    const token = streamioClient.createUserToken(uid);

    const userFeed = streamioClient.feed('Critiques', uid, token);

    const followStatsAPIResponse = await userFeed.followStats();

    try {
        return res.send(followStatsAPIResponse);
    } catch (error) {
        return res.send(error);
    }
});

exports.isFollowing = functions.https.onRequest(async (req, res) => {
    const myUID = req.body.myUID;
    const theirUID = req.body.theirUID;

    const myUserFeed = streamioClient.feed('Critiques', myUID);

    const getFollowAPIResponse = await myUserFeed.following({ offset: 0, limit: 1, filter: ['Critiques:' + theirUID] });

    try {
        return res.send(getFollowAPIResponse);
    } catch (error) {
        return res.send(error);
    }
});