const MongoClient = require('mongodb').MongoClient;
const functions = require('firebase-functions');
var ObjectID = require('mongodb').ObjectID;

const uri = "mongodb+srv://root:root@cluster0.htul7.mongodb.net/Critic?retryWrites=true&w=majority";//TODO: Add this to firebase keys.
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
const dbName = 'Critic';
const critiquesColName = 'Critiques';

exports.list = functions.https.onRequest(async (req, res) => {
    const uid = req.body.uid;

    try {
        client.connect(err => {
            if (err) throw err;
            var query = { uid: uid };
            client.db(dbName).collection(critiquesColName).find(query).toArray((error, docs) => {
                if (err) throw err;
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
                created: new Date(),
                modified: new Date(),
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
            var query = {_id: new ObjectID(id)};
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
