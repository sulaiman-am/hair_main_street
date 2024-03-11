/* eslint-disable */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
require("dotenv").config();
const { initializeApp } = require("firebase-admin/app");
const { Timestamp } = require("firebase-admin/firestore");
initializeApp();
const t = Timestamp.now();
const db = admin.firestore();

async function sendFcmNotification(topic, body, title, data) {
  const message = {
    notification: {
      title: title,
      body: body,
    },
    data: {
      orderID: data,
    },
    topic: topic,
  };

  try {
    await admin.messaging().send(message);
    console.log("FCM notification sent successfully");
  } catch (error) {
    console.error("Error sending FCM notification:", error);
  }
}

async function sendEmail(email, subject, body) {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      type: "OAuth2",
      user: process.env.EMAIL,
      pass: process.env.PASSWORD,
      clientId: process.env.OAUTH_CLIENT_ID,
      clientSecret: process.env.OAUTH_CLIENT_SECRET,
      refreshToken: process.env.REFRESH_TOKEN,
    },
  });

  const mailOptions = {
    from: "hairmainstreetofficial01@gmail.com",
    to: email,
    subject: subject,
    html: body,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log("Email sent successfully");
  } catch (error) {
    console.error("Error sending email:", error);
  }
}

exports.notifyBuyerOnOrderStatusChange = functions.firestore
  .document("orders/{orderId}")
  .onUpdate(async (change, context) => {
    const newOrderData = change.after.data();
    const oldOrderData = change.before.data();

    if (newOrderData["order status"] !== oldOrderData["order status"]) {
      const buyerId = newOrderData["buyerID"];
      const buyerDoc = await db.collection("userProfile").doc(buyerId).get();
      const buyerData = buyerDoc.data();
      const orderID = context.params.orderId;
      const fcmTitle = "Order Status Update";
      const fcmBody = `Your order has been ${newOrderData["order status"]},\nKindly Confirm`;

      await db.collection("notifications").doc(buyerId).collection("notifications").add({
        "userID": buyerId,
        "extra data": orderID,
        "title": fcmTitle,
        "body": fcmBody,
        "time stamp": t,
      });

      if (buyerId && buyerData["token"]) {
        await sendFcmNotification(`buyer_${buyerId}`, fcmBody, fcmTitle, orderID);
      }

      if (buyerData && buyerData["email"]) {
        const emailSubject = "Order Status Update";
        const emailBody = `
          <p>Dear ${buyerData["fullname"]},</p>
          <p>Your order with ID: ${orderID} has been ${newOrderData["order status"]}, Kindly Confirm.</p>
        `;
        await sendEmail(buyerData["email"], emailSubject, emailBody);
      }
    }

    return null;
  });

exports.notifyOnOrderCreation = functions.firestore
  .document("orders/{orderId}")
  .onCreate(async (snapshot, context) => {
    const orderData = snapshot.data();
    const buyerId = orderData.buyerID;
    const buyerDoc = await db.collection("userProfile").doc(buyerId).get();
    const buyerData = buyerDoc.data();
    const vendorID = orderData.vendorID;
    const vendorDoc = await db.collection("userProfile").doc(vendorID).get();
    const vendorData = vendorDoc.data();
    const orderID = context.params.orderId;
    const fcmTitle = "New Order Created";
    const vendorFcmBody = "You have a new order for your product";
    const buyerFcmBody = "Your order has been created";
    const emailSubject = "New Order Created";
    const buyerEmailBody = `
      <p>Dear ${buyerData["fullname"]},</p>
      <p>Your order with ID: ${orderID} has been successfully created.</p>
    `;
    const vendorEmailBody = `
      <p>Dear ${vendorData["fullname"]},</p>
      <p>You have a new order for your product with ID: ${orderID}.</p>
    `;

    await db.collection("notifications").doc(buyerId).collection("notifications").add({
      "userID": buyerId,
      "extra data": orderID,
      "title": fcmTitle,
      "body": buyerFcmBody,
      "time stamp": t,
    });

    await db.collection("notifications").doc(vendorID).collection("notifications").add({
      "userID": vendorID,
      "extra data": orderID,
      "title": fcmTitle,
      "body": vendorFcmBody,
      "time stamp": t,
    });

    await sendFcmNotification(`buyer_${buyerId}`, buyerFcmBody, fcmTitle, orderID);
    await sendEmail(buyerData["email"], emailSubject, buyerEmailBody);

    await sendFcmNotification(`vendor_${vendorID}`, vendorFcmBody, fcmTitle, orderID);
    await sendEmail(vendorData["email"], emailSubject, vendorEmailBody);

    return null;
  });

// update amount withdrawable  
exports.processConfirmedOrder = functions.firestore
  .document('orders/{orderId}')
  .onUpdate(async (change, context) => {
    const orderId = context.params.orderId;
    const orderData = change.after.data();
    const previousOrderData = change.before.data();

    // Check if the order status changed to "confirmed"
    if (orderData["order status"] === 'confirmed' && previousOrderData["order status"] !== 'confirmed') {
      const vendorId = orderData.vendorID; // Assuming there's a field called "vendorId" in your order document
      const amountToRemit = orderData["payment price"]; // Adjust this based on your data model
      
      // Update the vendor's wallet collection
      const walletRef = db.collection('wallet').doc(vendorId);
      const walletDoc = await walletRef.get();
      
      if (walletDoc.exists) {
        const data = walletDoc.data();
        const currentAmount = data["withdrawable balance"] || 0;
        const updatedAmount = (Number(currentAmount) + Number(amountToRemit)).toString();
        //console.log(`current amount: ${currentAmount}`);
        //console.log(`updated amount: ${updatedAmount}`);
        // Update the wallet with the new amount
        await walletRef.update({
          "withdrawable balance": updatedAmount,
        });

        //console.log(`Amount remitted to vendor (${vendorId}): ${amountToRemit}`);
        return null;
      } else {
        console.error(`Wallet not found for vendor (${vendorId})`);
        return null;
      }
    }

    return null;
  });