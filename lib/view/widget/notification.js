//
////use token
//var admin = require('firebase-admin');
//
//var serviceAccount = require("./mangodev-1955a-firebase-adminsdk-nfxl9-ce9f3fd31b.json");
//
//admin.initializeApp({
//  credential: admin.credential.cert(serviceAccount),
//});
//
//
//async function friendRequest(currID, friendID) {
//  const curr = admin.firestore().collection('user').doc(currID).get();
//  const friend = admin.firestore().collection('user').doc(friendID).get();
//
//  await admin.messaging().sendToDevice(
//      curr.tokens, {
//    data: {
//      curr: JSON.stringify(curr),
//      friend: JSON.stringify(friend),
//    }
//  }, {
//    contentAvailable: true,
//    priprity: 'high',
//  }
//  )
//}