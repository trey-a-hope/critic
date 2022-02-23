const MongoClient = require('mongodb').MongoClient;
const functions = require('firebase-functions');
var ObjectID = require('mongodb').ObjectID;
const env = functions.config();
const client = new MongoClient(env.mongodb.connectionstring, { useNewUrlParser: true, useUnifiedTopology: true });
const dbName = 'Critic';
const critiquesColName = 'critiques';

exports.get = functions.https.onRequest(async (req, res) => {
    const id = req.body.id;
    const activityID = req.body.activityID;

    try {
        client.connect(err => {
            if (err) throw err;

            var query = {};

            if (id) {
                query['_id'] = { $lt:  new ObjectID(id) };
            } 

            if(activityID) {
                query['activityID'] = activityID;
            }

 
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

//TODO: Get this to work somehow.
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

exports.list = functions.https.onRequest(async (req, res) => {
    const limit = parseInt(req.body.limit);//Numbers come through as strings for mongodb for some reason.
    const last_id = req.body.last_id;
    const uid = req.body.uid;
    const imdbID = req.body.imdbID;

    try {
        client.connect(err => {
            if (err) throw err;

            var query = {};

            if (last_id) {
                query['_id'] = { $lt: new ObjectID(last_id) };
            } 

            if(uid){
                query['uid'] = uid;
            }

            if(imdbID){
                query['imdbID'] = imdbID;
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
    const id = req.body.id;
    const rating = req.body.rating;
    const imdbID = req.body.imdbID;
    const created = req.body.created;
    const modified = req.body.created;
    const activityID = req.body.activityID;

    try {
        client.connect(err => {
            if (err) throw err;
            var data = {
                _id: id,
                message: message,
                uid: uid,
                rating: rating,
                activityID: activityID,
                imdbID: imdbID,
                comments: [],
                likes: [],
                created: created,
                modified: modified,
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

exports.deleteAll = functions.https.onRequest(async (req, res) => {
    try {
        client.connect(err => {
            if (err) throw err;
            client.db(dbName).collection(critiquesColName).deleteMany({}, (err, docs) => {
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