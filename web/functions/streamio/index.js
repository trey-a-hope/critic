const functions = require('firebase-functions');
const { user } = require('firebase-functions/lib/providers/auth');
const env = functions.config();
const streamio = require('getstream');
const streamioClient = streamio.connect(env.streamio.apikey, env.streamio.apisecret, env.streamio.appid);

exports.addCritiqueToFeed = functions.https.onRequest((req, res) => {
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

    userFeed.addActivity({
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
    }).then((result) => {
        return res.send(result);
    }).catch((error) => {
        return res.send(error);
    });
});

exports.getUserFeed = functions.https.onRequest((req, res) => {
    const uid = req.body.uid;
    const limit = req.body.limit;
    const offset = req.body.offset;

    const userFeed = streamioClient.feed('Critiques', uid);

    userFeed.get({ limit: limit, offset: offset }).then((results) => {
        return res.send(results);
    }).catch((error) => {
        return res.send(error);
    });
});

exports.deleteCritiqueFromFeed = functions.https.onRequest((req, res) => {
    const uid = req.body.uid;
    const critiqueID = req.body.critiqueID;

    const userFeed = streamioClient.feed('Critiques', uid);

    userFeed.removeActivity(critiqueID).then((result) => {
        return res.send(result);
    }).catch((error) => {
        return res.send(error);
    });
});

//exports.followUser
//exports.unfollowUser
//exports.getFollowers
//exports.getFollowees