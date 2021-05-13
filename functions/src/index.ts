import * as admin from "firebase-admin";
admin.initializeApp();
import * as functions from "firebase-functions";
const db = admin.firestore();
const fcm = admin.messaging();

exports.sendToDevice = functions.firestore
    .document("chats/{chatid}/messages/{messagesId}")
    .onCreate(async (snapshot) => {
      const message = snapshot.data();
      console.log("Por aca " + message.receiverUid);
      if (message.type == "text") {
        const ownerDoc = db.collection("users").doc(message.receiverUid);
        const ownerData = ownerDoc.get();
        const token = (await ownerData).get("Token");
        console.log("Token " + token);

        const ownerDocOri = db.collection("users").doc(message.senderUid);
        const ownerDataOri = ownerDocOri.get();
        const nombre = (await ownerDataOri).get("username");
        if (token != null) {
          const payload: admin.messaging.MessagingPayload = {
            notification: {
              title: "New message from  " + nombre,
              body: message.content,
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              clickAction: "FLUTTER_NOTIFICATION_CLICK",
            },
          };
          fcm.sendToDevice(token, payload);
        }
      }
    });

exports.sendToDeviceUpdate = functions.firestore
    .document("chats/{chatid}/messages/{messagesId}")
    .onUpdate(async (snapshot) => {
      const message = snapshot.after.data();
      console.log("Por aca " + message.receiverUid);
      if (message.type == "text") {
        const ownerDoc = db.collection("users").doc(message.receiverUid);
        const ownerData = ownerDoc.get();
        const token = (await ownerData).get("Token");
        const isOnline = (await ownerData).get("isOnline");
        if(isOnline) {
          return;
        }
        console.log("Token " + token);
        console.log(message.content);

        const ownerDocOri = db.collection("users").doc(message.senderUid);
        const ownerDataOri = ownerDocOri.get();
        const nombre = (await ownerDataOri).get("username");
        if (token != null) {
          const payload: admin.messaging.MessagingPayload = {
            notification: {
              title: "New message from  " + nombre,
              body: message.content,
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              clickAction: "FLUTTER_NOTIFICATION_CLICK",
            },
          };
          fcm.sendToDevice(token, payload);
        }
      }
    });
