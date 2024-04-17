/* eslint-disable */

import { firestore, pubsub, https } from 'firebase-functions'
import { firestore as _firestore, messaging } from 'firebase-admin'
import { createTransport } from 'nodemailer'
require('dotenv').config()
import { initializeApp } from 'firebase-admin/app'
import { Timestamp } from 'firebase-admin/firestore'
initializeApp()
const t = Timestamp.now()
const db = _firestore()
import express from 'express'
import { post } from 'axios'
import cors from 'cors'
import { json } from 'body-parser'

const app = express()

const ADMIN_EMAIL =
  process.env.ADMIN_EMAIL ?? 'hairmainstreetofficial01@gmail.com'

//middle ware
app.use(json())
app.use(cors({ origin: true }))

app.post('/refund', async (req, res) => {
  const { transactionId, refundAmount, customerEmail } = req.body
  const paystackSecretKey = process.env.PAYSTACK_SECRET_KEY

  try {
    const response = await post(
      'https://api.paystack.co/refund',
      {
        transaction: transactionId,
        amount: refundAmount, // Optional: Specify the refund amount
        customerEmail: customerEmail
      },
      {
        headers: {
          Authorization: `Bearer ${paystackSecretKey}`,
          'Content-Type': 'application/json'
        }
      }
    )

    if (response.status === 200) {
      res
        .status(200)
        .send({ message: 'Refund initiated successfully', data: response.data })
    } else {
      res
        .status(response.status)
        .send({ message: 'Failed to initiate refund', error: response.data })
    }
  } catch (error) {
    console.error('Error initiating refund:', error)
    res
      .status(500)
      .send({ message: 'Internal server error', error: error.message })
  }
})

async function sendFcmNotification(topic, body, title, data) {
  const message = {
    notification: {
      title: title,
      body: body
    },
    data: {
      orderID: data
    },
    topic: topic
  }

  try {
    await messaging().send(message)
    console.log('FCM notification sent successfully')
  } catch (error) {
    console.error('Error sending FCM notification:', error)
  }
}

async function sendEmail(email, subject, body) {
  const transporter = createTransport({
    service: 'gmail',
    auth: {
      user: process.env.EMAIL,
      pass: process.env.APPPASSWORD // Replace with your app password
    }
  })

  const mailOptions = {
    from: 'hairmainstreetofficial01@gmail.com',
    to: email,
    subject: subject,
    html: body
  }

  try {
    await transporter.sendMail(mailOptions)
    console.log('Email sent successfully')
  } catch (error) {
    console.error('Error sending email:', error)
  }
}

export const notifyBuyerOnOrderStatusChange = firestore
  .document('orders/{orderId}')
  .onUpdate(async (change, context) => {
    const newOrderData = change.after.data()
    const oldOrderData = change.before.data()

    if (
      newOrderData['order status'] !== oldOrderData['order status'] &&
      newOrderData['order status'] !== 'expired'
    ) {
      const buyerId = newOrderData['buyerID']
      const buyerDoc = await db.collection('userProfile').doc(buyerId).get()
      const buyerData = buyerDoc.data()
      const orderID = context.params.orderId
      const fcmTitle = 'Order Status Update'
      const fcmBody = `Your order has been ${newOrderData['order status']},\nKindly Confirm`

      await db
        .collection('notifications')
        .doc(buyerId)
        .collection('notifications')
        .add({
          userID: buyerId,
          'extra data': orderID,
          title: fcmTitle,
          body: fcmBody,
          'time stamp': t
        })

      if (buyerId && buyerData['token']) {
        await sendFcmNotification(
          `buyer_${buyerId}`,
          fcmBody,
          fcmTitle,
          orderID
        )
      }

      if (buyerData && buyerData['email']) {
        const emailSubject = 'Order Status Update'
        const emailBody = `
          <p>Dear ${buyerData['fullname']},</p>
          <p>Your order with ID: ${orderID} has been ${newOrderData['order status']}, Kindly Confirm.</p>
        `
        await sendEmail(buyerData['email'], emailSubject, emailBody)
      }
    }

    return null
  })

export const notifyOnOrderCreation = firestore
  .document('orders/{orderId}')
  .onCreate(async (snapshot, context) => {
    const orderData = snapshot.data()
    const buyerId = orderData.buyerID
    const buyerDoc = await db.collection('userProfile').doc(buyerId).get()
    const buyerData = buyerDoc.data()
    const vendorID = orderData.vendorID
    const vendorDoc = await db.collection('userProfile').doc(vendorID).get()
    const vendorData = vendorDoc.data()
    const orderID = context.params.orderId
    const fcmTitle = 'New Order Created'
    const vendorFcmBody = 'You have a new order for your product'
    const buyerFcmBody = 'Your order has been created'
    const emailSubject = 'New Order Created'
    const buyerEmailBody = `
      <p>Dear ${buyerData['fullname']},</p>
      <p>Your order with ID: ${orderID} has been successfully created.</p>
    `
    const vendorEmailBody = `
      <p>Dear ${vendorData['fullname']},</p>
      <p>You have a new order for your product with ID: ${orderID}.</p>
    `

    await db
      .collection('notifications')
      .doc(buyerId)
      .collection('notifications')
      .add({
        userID: buyerId,
        'extra data': orderID,
        title: fcmTitle,
        body: buyerFcmBody,
        'time stamp': t
      })

    await db
      .collection('notifications')
      .doc(vendorID)
      .collection('notifications')
      .add({
        userID: vendorID,
        'extra data': orderID,
        title: fcmTitle,
        body: vendorFcmBody,
        'time stamp': t
      })

    await sendFcmNotification(
      `buyer_${buyerId}`,
      buyerFcmBody,
      fcmTitle,
      orderID
    )
    await sendEmail(buyerData['email'], emailSubject, buyerEmailBody)

    await sendFcmNotification(
      `vendor_${vendorID}`,
      vendorFcmBody,
      fcmTitle,
      orderID
    )
    await sendEmail(vendorData['email'], emailSubject, vendorEmailBody)

    return null
  })

export const updateWalletAfterOrderPlacement = firestore
  .document('orders/{orderId}')
  .onCreate(async (snapshot, context) => {
    const order = snapshot.data()
    const vendorId = order.vendorID
    const paymentPrice = order['payment price']
    const orderId = context.params.orderId

    // Check if wallet exists for the vendor
    const walletRef = db.collection('wallet').doc(vendorId)
    const walletSnapshot = await walletRef.get()

    if (walletSnapshot.exists) {
      // Wallet exists, update balance
      const walletData = walletSnapshot.data()
      const currentBalance = walletData.balance || 0

      // Update balance
      await walletRef.update({
        balance: currentBalance + paymentPrice
      })
    } else {
      // Wallet does not exist, create new wallet document
      await walletRef.set({
        balance: paymentPrice
      })
    }

    const transactionRef = db
      .collection('wallet')
      .doc(vendorId)
      .collection('transactions')
      .doc(orderId)
    await transactionRef.set({
      orderId: orderId,
      type: 'credit',
      timestamp: _firestore.FieldValue.serverTimestamp(),
      amount: paymentPrice
    })

    console.log('Wallet updated successfully')
    return null
  })

export const processConfirmedOrder = firestore
  .document('orders/{orderId}')
  .onUpdate(async (change, context) => {
    const orderId = context.params.orderId
    const orderData = change.after.data()
    const previousOrderData = change.before.data()

    // Check if the order status changed to "confirmed"
    if (
      orderData['order status'] === 'confirmed' &&
      previousOrderData['order status'] !== 'confirmed'
    ) {
      const vendorId = orderData.vendorID // Assuming there's a field called "vendorId" in your order document
      const amountToRemit = orderData['payment price'] // Adjust this based on your data model

      // Update the vendor's wallet collection
      const walletRef = db.collection('wallet').doc(vendorId)
      const walletDoc = await walletRef.get()

      if (walletDoc.exists) {
        const data = walletDoc.data()
        const currentAmount = data['withdrawable balance'] || 0
        const updatedAmount = (
          Number(currentAmount) + Number(amountToRemit)
        ).toString()
        //console.log(`current amount: ${currentAmount}`);
        //console.log(`updated amount: ${updatedAmount}`);
        // Update the wallet with the new amount
        await walletRef.update({
          'withdrawable balance': updatedAmount
        })

        //console.log(`Amount remitted to vendor (${vendorId}): ${amountToRemit}`);
        return null
      } else {
        console.error(`Wallet not found for vendor (${vendorId})`)
        return null
      }
    }

    return null
  })

export const checkInstallmentPayments = pubsub
  .schedule('every 15 hours')
  .onRun(async context => {
    const currentTime = Date.now()

    // Query orders with "installment" payment method
    const installmentOrdersSnapshot = await db
      .collection('orders')
      .where('payment method', '==', 'installment')
      .get()

    installmentOrdersSnapshot.forEach(async doc => {
      const order = doc.data()
      const orderID = doc.id
      const vendorRef = await db
        .collection('vendors')
        .doc(order['vendorID'])
        .get()
      const buyerRef = await db
        .collection('userProfile')
        .doc(order['buyerID'])
        .get()
      const totalInstallments = order['installment number'] || 1 // Default to 1 if not specified
      const installmentDuration = vendorRef.data()['installment duration'] || 0 // Default to 3 days if not specified
      const installmentsMade = order['installment paid'] || 1
      const firstInstallmentTime =
        order['created at'].seconds * 1000 +
        order['created at'].nanoseconds / 1000000

      // Calculate the deadline for the next installment
      const nextInstallmentDeadline =
        firstInstallmentTime + installmentsMade * installmentDuration
      // console.log(nextInstallmentDeadline)
      // console.log(installmentDuration)
      // console.log(currentTime)

      // If the current time exceeds the deadline for the next installment, update order status to "expired"
      if (
        currentTime > nextInstallmentDeadline &&
        installmentsMade < totalInstallments
      ) {
        await db
          .collection('orders')
          .doc(orderID)
          .update({ 'order status': 'expired' })

        // Optionally, send notification to buyer about order expiration
        // sendExpirationNotification(order.buyerID, orderID);
        const fcmTitle = 'Order Expired'
        const fcmBody = `Your Order with ID: ${orderID} has expired, Kindly Order Again`

        await sendFcmNotification(
          `buyer_${order['buyerID']}`,
          fcmBody,
          fcmTitle,
          orderID
        )
        await db
          .collection('notifications')
          .doc(order['buyerID'])
          .collection('notifications')
          .set({
            body: fcmBody,
            'extra data': orderID,
            'time stamp': t,
            title: fcmTitle,
            userID: order['buyerID']
          })
        await sendEmail(buyerRef.data()['email'], 'Order Expired', fcmBody)
      } else {
        // Optionally, send payment reminders if needed
        if (currentTime + 3 * 24 * 60 * 60 * 1000 > nextInstallmentDeadline) {
          const buyerFcmBody =
            'Please remember to pay your installment payment before the deadline runs out'
          const fcmTitle = 'Payment Reminder'
          // Send reminder 3 days before the deadline
          // sendPaymentReminder(order.buyerID, orderID);
          await sendFcmNotification(
            `buyer_${order['buyerID']}`,
            buyerFcmBody,
            fcmTitle,
            orderID
          )
          await db
            .collection('notifications')
            .doc(order['buyerID'])
            .collection('notifications')
            .set({
              body: buyerFcmBody,
              'extra data': orderID,
              'time stamp': t,
              title: fcmTitle,
              userID: order['buyerID']
            })
          await sendEmail(
            buyerRef.data()['email'],
            'Payment Reminder',
            'Please remember to pay your installment payment before the deadline runs out'
          )
        }

        // Send reminder 1 day before the deadline
        if (currentTime + 24 * 60 * 60 * 1000 > nextInstallmentDeadline) {
          // Send reminder 1 day before the deadline
          // sendOneDayReminder(order.buyerID, orderID);
          const buyerFcmBody =
            'Please remember to pay your installment payment before the deadline runs out'
          const fcmTitle = 'Payment Reminder'
          // Send reminder 3 days before the deadline
          // sendPaymentReminder(order.buyerID, orderID);
          await sendFcmNotification(
            `buyer_${order['buyerID']}`,
            buyerFcmBody,
            fcmTitle,
            orderID
          )
          await db
            .collection('notifications')
            .doc(order['buyerID'])
            .collection('notifications')
            .set({
              body: buyerFcmBody,
              'extra data': orderID,
              'time stamp': t,
              title: fcmTitle,
              userID: order['buyerID']
            })
          await sendEmail(
            buyerRef.data()['email'],
            'Payment Reminder',
            'Please remember to pay your installment payment before the deadline runs out'
          )
        }
      }
    })
    //console.log('this ran')
    return null
  })

export const api = https.onRequest(app)

export const handleRefundRequestCreation = firestore
  .document('refunds/{requestId}')
  .onCreate(async (snapshot, context) => {
    try {
      // Get the refund request data
      const refundRequestData = snapshot.data()
      if (!refundRequestData) {
        throw new Error('Refund request data is missing')
      }

      // Get the order associated with the refund request
      const orderId = refundRequestData['orderID']
      const orderSnapshot = await db.collection('orders').doc(orderId).get()
      const orderData = orderSnapshot.data()
      if (!orderData) {
        throw new Error('Order data is missing')
      }

      // Get user and vendor data
      const buyerId = orderData['buyerID']
      const vendorId = orderData['vendorID']
      const buyerSnapshot = await db
        .collection('userProfile')
        .doc(buyerId)
        .get()
      const vendorSnapshot = await db
        .collection('userProfile')
        .doc(vendorId)
        .get()
      const buyerData = buyerSnapshot.data()
      const vendorData = vendorSnapshot.data()
      if (!buyerData || !vendorData) {
        throw new Error('Buyer or vendor data is missing')
      }

      // Send email notifications
      await sendEmail(
        buyerData['email'],
        'Refund Request Submitted',
        'Your refund request has been submitted successfully.'
      )
      await sendEmail(
        vendorData['email'],
        'New Refund Request',
        'A new refund request has been submitted by a buyer.'
      )
      await sendEmail(
        ADMIN_EMAIL,
        'New Refund Request',
        'A new refund request has been submitted.'
      )

      //send FCM notifications
      await sendFcmNotification(
        `buyer_${buyerId}`,
        'Your refund request has been submitted successfully.',
        'Refund Request Submitted',
        orderId
      )

      await sendFcmNotification(
        `vendor_${vendorId}`,
        'A new refund request has been submitted by a buyer.',
        'New Refund Request',
        orderId
      )

      //update notifications in db
      await db
        .collection('notifications')
        .doc(buyerId)
        .collection('notifications')
        .add({
          userID: buyerId,
          'extra data': orderId,
          title: 'Refund Request Submitted',
          body: 'Your refund request has been submitted successfully.',
          'time stamp': t
        })

      await db
        .collection('notifications')
        .doc(vendorId)
        .collection('notifications')
        .add({
          userID: vendorId,
          'extra data': orderId,
          title: 'New Refund Request',
          body: 'A new refund request has been submitted by a buyer.',
          'time stamp': t
        })

      return null
    } catch (error) {
      console.error('Error handling refund request creation:', error)
      return null
    }
  })

export const handleOrderCancelRequestCreation = firestore
  .document('cancellations/{requestID}')
  .onCreate(async (snapshot, context) => {
    try {
      // Get the cancel request data
      const cancelRequestData = snapshot.data()
      if (!cancelRequestData) {
        throw new Error('Cancel request data is missing')
      }

      // Get the order associated with the cancel request
      const orderId = cancelRequestData['orderID']
      const orderSnapshot = await db.collection('orders').doc(orderId).get()
      const orderData = orderSnapshot.data()
      if (!orderData) {
        throw new Error('Order data is missing')
      }

      // Get user and vendor data
      const buyerId = orderData['buyerID']
      const vendorId = orderData['vendorID']
      const buyerSnapshot = await db
        .collection('userProfile')
        .doc(buyerId)
        .get()
      const vendorSnapshot = await db
        .collection('userProfile')
        .doc(vendorId)
        .get()
      const buyerData = buyerSnapshot.data()
      const vendorData = vendorSnapshot.data()
      if (!buyerData || !vendorData) {
        throw new Error('Buyer or vendor data is missing')
      }

      // Send email notifications
      await sendEmail(
        buyerData['email'],
        'Order Cancel Request Submitted',
        'Your order cancel request has been submitted successfully.'
      )
      await sendEmail(
        vendorData['email'],
        'New Order Cancel Request',
        'A new order cancel request has been submitted by a buyer.'
      )
      await sendEmail(
        ADMIN_EMAIL,
        'New Order Cancel Request',
        'A new order cancel request has been submitted.'
      )

      //send fcm notification to buyer and vendor
      await sendFcmNotification(
        `buyer_${buyerId}`,
        'Your order cancel request has been submitted successfully.',
        'Order Cancel Request Submitted',
        orderId
      )

      await sendFcmNotification(
        `vendor_${vendorId}`,
        'A new order cancel request has been submitted by a buyer.',
        'New Order Cancel Request',
        orderId
      )

      await db
        .collection('notifications')
        .doc(buyerId)
        .collection('notifications')
        .add({
          userID: buyerId,
          'extra data': orderId,
          title: 'Order Cancel Request Submitted',
          body: 'Your order cancel request has been submitted successfully.',
          'time stamp': t
        })

      await db
        .collection('notifications')
        .doc(vendorId)
        .collection('notifications')
        .add({
          userID: vendorId,
          'extra data': orderId,
          title: 'New Order Cancel Request',
          body: 'A new order cancel request has been submitted by a buyer.',
          'time stamp': t
        })

      return null
    } catch (error) {
      console.error('Error handling order cancel request creation:', error)
      return null
    }
  })

async function initiateRefund(transactionId, amount) {
  try {
    const response = await post(
      'https://api.paystack.co/refund',
      {
        amount,
        transaction: transactionId
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
          'Content-Type': 'application/json'
        }
      }
    )

    return response.data.data
  } catch (error) {
    console.error('Error initiating refund:', error.response.data)
    throw error
  }
}

export const handleRefunds = firestore
  .document('refunds/{refundId}')
  .onUpdate(async (change, context) => {
    const refundId = context.params.refundId
    const newValue = change.after.data()
    const oldValue = change.before.data()

    if (
      newValue['refund status'] === 'approved' &&
      oldValue['refund status'] !== 'approved'
    ) {
      try {
        // ... (Retrieve order data, calculate refund amount, get user and vendor data)
        const orderId = newValue['orderID']
        const orderSnapshot = await db.collection('orders').doc(orderId).get()
        const orderData = orderSnapshot.data()
        if (!orderData) {
          throw new Error('Order data is missing')
        }

        // Get payment amount and calculate refund amount based on the reason
        const paymentAmount = orderData['payment price']
        const transactionId = orderData['transactionID']
        let refundAmount
        if (
          newValue['reason'] === 'Defective Product' ||
          newValue['reason'] === 'Received Wrong Item'
        ) {
          refundAmount = paymentAmount
        } else {
          refundAmount = paymentAmount - paymentAmount * 0.1
        }

        // Get user and vendor data
        const buyerId = orderData['buyerID']
        const vendorId = orderData['vendorID']
        const buyerSnapshot = await db
          .collection('userProfile')
          .doc(buyerId)
          .get()
        const vendorSnapshot = await db
          .collection('userProfile')
          .doc(vendorId)
          .get()
        const buyerData = buyerSnapshot.data()
        const vendorData = vendorSnapshot.data()
        if (!buyerData || !vendorData) {
          throw new Error('Buyer or vendor data is missing')
        }

        // Send email notifications
        await Promise.all([
          sendEmail(
            buyerData['email'],
            'Refund Approved',
            'Your refund has been approved.'
          ),
          sendEmail(
            vendorData['email'],
            'Refund Approved',
            'A refund has been approved.'
          ),
          sendEmail(
            ADMIN_EMAIL,
            'Refund Approved',
            'A refund has been approved.'
          )
        ])

        //send notification to both vendor and buyer
        const buyerFcmBody = 'Refund has been approved.'
        const fcmTitle = 'Refund Approved'

        await Promise.all([
          sendFcmNotification(
            `buyer_${buyerId}`,
            buyerFcmBody,
            fcmTitle,
            orderId
          ),
          db
            .collection('notifications')
            .doc(buyerId)
            .collection('notifications')
            .set({
              body: buyerFcmBody,
              'extra data': orderId,
              'time stamp': t,
              title: fcmTitle,
              userID: buyerId
            }),

          sendFcmNotification(
            `vendor_${vendorId}`,
            buyerFcmBody,
            fcmTitle,
            orderId
          ),
          db
            .collection('notifications')
            .doc(vendorId)
            .collection('notifications')
            .set({
              body: buyerFcmBody,
              'extra data': orderId,
              'time stamp': t,
              title: fcmTitle,
              userID: vendorId
            })
        ])

        // Call Paystack refund API
        const refundResponse = await initiateRefund(transactionId, refundAmount)

        if (refundResponse.status === 'processed') {
          const refundWebhookUrl = `https://${process.env.PROJECT_ID}.firebaseapp.com/paystackRefundWebhook`

          // Register the webhook with Paystack
          await post(
            'https://api.paystack.co/webhook',
            {
              url: refundWebhookUrl,
              events: ['refund.processed']
            },
            {
              headers: {
                Authorization: `Bearer ${paystackSecretKey}`,
                'Content-Type': 'application/json'
              }
            }
          )
        } else {
          console.error('Refund failed:', refundResponse)
        }
      } catch (error) {
        console.error('Error processing refund:', error)
      }
    }
  })

export const paystackRefundWebhook = https.onRequest(async (req, res) => {
  // Verify the Paystack webhook signature
  const signature = req.headers['x-paystack-signature']
  if (!signature || !validateSignature(req.rawBody, signature)) {
    res.status(400).send('Invalid signature')
    return
  }

  const event = req.body

  if (event.event === 'refund.processed') {
    const refundId = event.data.id

    try {
      // Update refund status to completed in Firestore
      await db
        .collection('refunds')
        .doc(refundId)
        .update({ 'refund status': 'completed' })

      // Get buyer and vendor data from the refund document
      const refundSnapshot = await db.collection('refunds').doc(refundId).get()
      const refundData = refundSnapshot.data()
      const orderSnapshot = await db
        .collection('orders')
        .doc(refundData['orderID'])
        .get()
      const orderData = orderSnapshot.data()
      const buyerId = orderData['buyerID']
      const vendorId = orderData['vendorID']

      const buyerSnapshot = await db
        .collection('userProfile')
        .doc(buyerId)
        .get()
      const vendorSnapshot = await db
        .collection('userProfile')
        .doc(vendorId)
        .get()
      const buyerData = buyerSnapshot.data()
      const vendorData = vendorSnapshot.data()

      // Send emails about refund completion
      await Promise.all([
        sendEmail(
          ADMIN_EMAIL,
          'Refund Completed',
          'A refund has been completed.'
        ),
        sendEmail(
          vendorData['email'],
          'Refund Completed',
          'A refund has been completed.'
        ),
        sendEmail(
          buyerData['email'],
          'Refund Completed',
          'Your refund has been completed.'
        )
      ])

      //send notification to both vendor and buyer
      const buyerFcmBody = 'Refund has been completed.'
      const fcmTitle = 'Refund Completed'

      await Promise.all([
        sendFcmNotification(
          `buyer_${buyerId}`,
          buyerFcmBody,
          fcmTitle,
          refundData['orderID']
        ),
        db
          .collection('notifications')
          .doc(buyerId)
          .collection('notifications')
          .set({
            body: buyerFcmBody,
            'extra data': refundData['orderID'],
            'time stamp': t,
            title: fcmTitle,
            userID: buyerId
          }),

        sendFcmNotification(
          `vendor_${vendorId}`,
          buyerFcmBody,
          fcmTitle,
          refundData['orderID']
        ),
        db
          .collection('notifications')
          .doc(vendorId)
          .collection('notifications')
          .set({
            body: buyerFcmBody,
            'extra data': refundData['orderID'],
            'time stamp': t,
            title: fcmTitle,
            userID: vendorId
          })
      ])

      res.status(200).send('Webhook received and processed successfully.')
    } catch (error) {
      console.error('Error processing refund webhook:', error)
      res.status(500).send('Error processing webhook')
    }
  } else {
    res.status(200).send('Webhook received but not processed.')
  }
})

// Helper function to validate Paystack webhook signature
function validateSignature(body, signature) {
  const crypto = require('crypto')
  const hash = crypto
    .createHmac('sha512', process.env.PAYSTACK_SECRET_KEY)
    .update(JSON.stringify(body))
    .digest('hex')

  return hash === signature
}

