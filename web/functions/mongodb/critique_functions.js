const MongoClient = require('mongodb').MongoClient;
const assert = require('assert');
const functions = require('firebase-functions');

const uri = "mongodb+srv://root:root@cluster0.htul7.mongodb.net/Critic?retryWrites=true&w=majority";//TODO: Add this to firebase keys.
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
const dbName = 'Critic';
const critiquesColName = 'Critiques';
const usersColName = 'Users';
const suggestionsColName = 'Suggestions';

/*
    List critiques.
*/

exports.critiques = functions.https.onRequest(async (req, res) => {
    try {
        client.connect(err => {
            assert.equal(null, err);
            client.db(dbName).collection(critiquesColName).find({}).toArray((error, docs) => {
                assert.equal(null, error);
                client.close();
                return res.send(docs);
            });
        });
    } catch (err) {
        response.send(err);
    }
});