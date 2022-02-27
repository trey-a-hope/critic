const functions = require('firebase-functions');
const firebase = require('firebase-admin');
const { v4: uuidv4 } = require('uuid');
const fs = require('fs');
const path = require('path');
const os = require('os');
const json2csv = require('json2csv');

exports.generateApplicationCsv = functions.pubsub
    .topic("generate-application-csv")
    .onPublish(async message => {

        // Gets the documents from the firestore collection.
        const usersSnapshot = await firebase
            .firestore()
            .collection('Users')
            .get();

        const users = usersSnapshot.docs.map(doc => doc.data());

        // CSV field headers.
        const fields = [
            'username',
            'email',
            'uid',
            'created',
        ];

        // Get csv output.
        const output = await json2csv.parseAsync(users, { fields });

        // Generate filename.
        const dateTime = new Date().toISOString().replace(/\W/g, "");
        const filename = `old_users_${dateTime}.csv`;

        const tempLocalFile = path.join(os.tmpdir(), filename);

        return new Promise((resolve, reject) => {
            // Write contents of csv into the temp file.
            fs.writeFile(tempLocalFile, output, error => {
                if (error) {
                    reject(error);
                    return;
                }
                const bucket = firebase.storage().bucket();

                // Upload the file into the current firebase project default bucket.
                bucket
                    .upload(tempLocalFile, { 
                        destination: `Documents/${filename}`, 
                        // Workaround: firebase console not generating token for files
                        // uploaded via Firebase Admin SDK
                        // https://github.com/firebase/firebase-admin-node/issues/694
                        metadata: {
                            metadata: {
                                firebaseStorageDownloadTokens: uuidv4(),
                            }
                        },
                    })
                    .then(() => resolve())
                    .catch(errorr => reject(errorr));
            });
        });
    });