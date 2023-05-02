'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const firebase = admin.initializeApp();


//BUG
// exports.onDeleteSubject = functions.firestore.document('/subjects/{id}')
//   .onDelete(async (snap, context) => {
//     const data = snap.data();
//     console.log('[onDeleteSubject] Subject deleted', `${context.params.id}`);

//     const results = (await Promise.all([admin.firestore().collection('quizs')
//       .where('subjectId', "==", context.params.id)
//       .get()]))[0];

//     console.log(typeof results);
//     return;

//     for (const item of results) {
//       const data = item.data();
//       console.log('[onDeleteSubject] delete quiz', `${data.id}`);
//       admin.firestore().collection('quizs').doc(data.id).delete();
//     }

//     console.log('[onDeleteSubject] done', `${context.params.id}`);
//     return;
//   });

exports.onDeleteGallery = functions.firestore.document('/gallery/{id}')
  .onDelete(async (snap, context) => {
    const data = snap.data();
    console.log('[onDeleteGallery]', `gallery/images/${data.fileName}`);
    const bucket = firebase.storage().bucket();
    return bucket.deleteFiles({
      prefix: `gallery/images/${data.fileName}`
    });
  });


//  Deploy these cloud functions using Firebase CLI using following command:
//     firebase login
//     firebase deploy --only functions