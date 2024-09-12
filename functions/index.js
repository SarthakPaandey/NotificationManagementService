/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
// Remove or use these variables
// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

admin.initializeApp();

/**
 * Sends a notification to a specific device.
 * @param {string} token - The FCM token of the device.
 * @param {string} title - The title of the notification.
 * @param {string} body - The body of the notification.
 * @return {Promise<void>}
 */
const sendNotificationToDevice = async (token, title, body) => {
  const message = {
    notification: {
      title: title,
      body: body,
    },
    token: token,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log("Successfully sent message:", response);
  } catch (error) {
    console.error("Error sending message:", error);
  }
};

/**
 * Sends a notification when a new order is created.
 */
exports.sendNotificationOnNewOrder = functions.firestore
    .document("orders/{orderId}")
    .onCreate(async (snap, context) => {
      const newOrder = snap.data();
      const userRef = admin.firestore().collection("users")
          .doc(newOrder.userId);

      const userDoc = await userRef.get();
      if (userDoc.exists && userDoc.data().fcmToken) {
        await sendNotificationToDevice(
            userDoc.data().fcmToken,
            "New Order Created",
            "Your order has been successfully placed!",
        );
      }
    });

/**
 * Sends a notification when an order status is updated.
 */
exports.sendNotificationOnOrderUpdate = functions.firestore
    .document("orders/{orderId}")
    .onUpdate(async (change, context) => {
      const newValue = change.after.data();
      const previousValue = change.before.data();

      if (newValue.status !== previousValue.status) {
        const userRef = admin.firestore().collection("users")
            .doc(newValue.userId);

        const userDoc = await userRef.get();
        if (userDoc.exists && userDoc.data().fcmToken) {
          await sendNotificationToDevice(
              userDoc.data().fcmToken,
              "Order Status Updated",
              `Your order status has been updated to ${newValue.status}`,
          );
        }
      }
    });
