const MongoClient = require('mongodb').MongoClient;
const functions = require('firebase-functions');
var ObjectID = require('mongodb').ObjectID;
const env = functions.config();
const client = new MongoClient(env.mongodb.connectionstring, { useNewUrlParser: true, useUnifiedTopology: true });
const dbName = 'Critic';
const critiquesColName = 'Critiques';

exports.listSimilar = functions.https.onRequest(async (req, res) => {
    const id = req.body.id;
    const imdbID = req.body.imdbID;

    try {
        client.connect(err => {
            if (err) throw err;

            var query;

            if (!id) {
                query = { imdbID: imdbID };
            } else {
                query = { imdbID: imdbID, _id: { '$ne': new ObjectID(id) } };
            }

            var sort = { _id: -1 };

            client
                .db(dbName)
                .collection(critiquesColName)
                .find(query)
                .sort(sort)
                .toArray((error, docs) => {
                    if (error) throw error;
                    console.log(docs);
                    return res.send(docs);
                    //client.close();
                });
        });
    } catch (err) {
        return res.send(err);
    }
});

exports.get = functions.https.onRequest(async (req, res) => {
    const id = req.body.id;

    try {
        client.connect(err => {
            if (err) throw err;

            var query = { _id: new ObjectID(id) };

            client
                .db(dbName)
                .collection(critiquesColName)
                .findOne(query, (error, doc) => {
                    if (error) throw error;
                    console.log(doc);
                    return res.send(doc);
                    //client.close();
                });
        });
    } catch (err) {
        return res.send(err);
    }
});

exports.count = functions.https.onRequest(async (req, res) => {
    const uid = req.body.uid;

    try {
        client.connect(err => {
            if (err) throw err;

            var query;

            if (!uid) {
                query = {};
            } else {
                query = { uid: uid };
            }

            //TODO: Get this to work somehow.
            client
                .db(dbName)
                .collection(critiquesColName)
                .countDocuments(query, {}).then((value) => {
                    return res.send(value);
                }).catch((error) => {
                    return res.send(error);
                });
        });
    } catch (err) {
        return res.send(err);
    }
});

exports.listByUser = functions.https.onRequest(async (req, res) => {
    const uid = req.body.uid;
    const limit = parseInt(req.body.limit);//Numbers come through as strings for mongodb for some reason.
    const last_id = req.body.last_id;

    try {
        client.connect(err => {
            if (err) throw err;

            var query;

            if (!last_id) {
                query = { uid: uid };
            } else {
                query = { uid: uid, _id: { $gt: new ObjectID(last_id) } };
            }

            var sort = { _id: -1 };

            client
                .db(dbName)
                .collection(critiquesColName)
                .find(query)
                .limit(limit)
                .sort(sort)
                .toArray((error, docs) => {
                    if (error) throw error;
                    console.log(docs);
                    return res.send(docs);
                    //client.close();
                });
        });
    } catch (err) {
        return res.send(err);
    }
});

exports.listByGenre = functions.https.onRequest(async (req, res) => {
    const genre = req.body.genre;
    const limit = parseInt(req.body.limit);//Numbers come through as strings for mongodb for some reason.
    const last_id = req.body.last_id;

    try {
        client.connect(err => {
            if (err) throw err;

            var query;

            if (!last_id) {
                query = { genres: genre };
            } else {
                query = { genres: genre, _id: { $gt: new ObjectID(last_id) } };
            }

            var sort = { _id: -1 };

            client
                .db(dbName)
                .collection(critiquesColName)
                .find(query)
                .limit(limit)
                .sort(sort)
                .toArray((error, docs) => {
                    if (error) throw error;
                    console.log(docs);
                    return res.send(docs);
                    //client.close();
                });
        });
    } catch (err) {
        return res.send(err);
    }
});


exports.create = functions.https.onRequest(async (req, res) => {
    const message = req.body.message;
    const uid = req.body.uid;
    const rating = req.body.rating;
    const imdbID = req.body.imdbID;
    const genres = req.body.genres;
    const created = req.body.created;
    const modified = req.body.created;

    try {
        client.connect(err => {
            if (err) throw err;
            var data = {
                message: message,
                uid: uid,
                rating: rating,
                imdbID: imdbID,
                comments: [],
                likes: [],
                created: created,
                modified: modified,
                genres: genres,
            };
            client.db(dbName).collection(critiquesColName).insertOne(data, (err, _) => {
                if (err) throw err;
                //client.close();
                return res.send(true);
            });
        });
    } catch (err) {
        return res.send(err);
    }
});

exports.delete = functions.https.onRequest(async (req, res) => {
    const id = req.body.id;

    try {
        client.connect(err => {
            if (err) throw err;
            var query = { _id: new ObjectID(id) };
            client.db(dbName).collection(critiquesColName).deleteOne(query, (err, docs) => {
                if (err) throw err;
                console.log('Delete success.');
                return res.send(true);
                //client.close();
            });
        });
    } catch (err) {
        return res.send(err);
    }
});

exports.update = functions.https.onRequest(async (req, res) => {
    const id = req.body.id;
    const params = req.body.params;

    try {
        client.connect(err => {
            if (err) throw err;
            var query = { _id: new ObjectID(id) };
            var newvalues = { $set: params };
            client.db(dbName).collection(critiquesColName).updateOne(query, newvalues, (err, docs) => {
                if (err) throw err;
                console.log('Update success.');
                return res.send(true);
                //client.close();
            });
        });
    } catch (err) {
        return res.send(err);
    }
});

exports.addComment = functions.https.onRequest(async (req, res) => {
    const id = req.body.id;
    const comment = req.body.comment;

    //Add timestamp.
    comment['created'] = new Date();

    try {
        client.connect(err => {
            if (err) throw err;
            var query = { _id: new ObjectID(id) };
            var newvalues = { $push: { comments: comment } };
            client.db(dbName).collection(critiquesColName).updateOne(query, newvalues, (err, docs) => {
                if (err) throw err;
                console.log('Update success.');
                return res.send(true);
                //client.close();
            });
        });
    } catch (err) {
        return res.send(err);
    }
});

exports.addLike = functions.https.onRequest(async (req, res) => {
    const id = req.body.id;
    const uid = req.body.uid;

    try {
        client.connect(err => {
            if (err) throw err;
            var query = { _id: new ObjectID(id) };
            var newvalues = { $push: { likes: uid } };
            client.db(dbName).collection(critiquesColName).updateOne(query, newvalues, (err, docs) => {
                if (err) throw err;
                console.log('Update success.');
                return res.send(true);
                //client.close();
            });
        });
    } catch (err) {
        return res.send(err);
    }
});

exports.removeLike = functions.https.onRequest(async (req, res) => {
    const id = req.body.id;
    const uid = req.body.uid;

    try {
        client.connect(err => {
            if (err) throw err;
            var query = { _id: new ObjectID(id) };
            var newvalues = { $pull: { likes: uid } };
            client.db(dbName).collection(critiquesColName).updateOne(query, newvalues, (err, docs) => {
                if (err) throw err;
                console.log('Update success.');
                return res.send(true);
                //client.close();
            });
        });
    } catch (err) {
        return res.send(err);
    }
});