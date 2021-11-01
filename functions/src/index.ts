/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import algoliasearch from "algoliasearch";
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

const algoliaClient = algoliasearch(functions.config()
    .algolia.appid, functions.config().algolia.apikey);

const collectionIndexName = functions.config()
    .projectId === "IDMAPSSM" ?
"Services_dev" : "Services_prod";
const collectionIndex = algoliaClient.initIndex(collectionIndexName);

export const sendCollectionToAlgolia = functions.https.onRequest(async (_req, res) => {
  // This array will contain all records to be indexed in Algolia.
  // A record does not need to necessarily contain all properties of the Firestore document,
  // only the relevant ones.
  const algoliaRecords : any[] = [];

  // Retrieve all documents from the COLLECTION collection.
  const querySnapshot = await db.collection("Services").get();

  querySnapshot.docs.forEach((doc) => {
    const document = doc.data();
    // Essentially, you want your records to contain any information that facilitates search,
    // display, filtering, or relevance. Otherwise, you can leave it out.
    const record = {
      objectID: doc.id,
      Category: document.category,
      Title: document.title,
      Description: document.description,
      Company: document.Company,
      ShortCaption: document.shortCaption,
    };

    algoliaRecords.push(record);
  });

  // After all records are created, we save them to
  collectionIndex.saveObjects(algoliaRecords, (_error: any, content: any) => {
    res.status(200).send("COLLECTION was indexed to Algolia successfully.");
  });
});


export const sendToDevice = functions.firestore
    .document("Customer Requests/{uid}")
    .onCreate(async (snapshot) => {
      const Appointments = snapshot.data();

      const querySnapshot = await db
          .collection("Users")
          .doc(Appointments.CompanyUID)
          .collection("tokens")
          .get();

      const tokens = querySnapshot.docs.map((snap) => snap.id);

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: "New Request!",
          body: `${Appointments.Customer} is requesting  
          ${Appointments.AppointmentService} 
for ${Appointments.RequestedDate}`,
          // icon: 'your-icon-url',
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      return fcm.sendToDevice(tokens, payload);
    });

export const sendToDeviceApp = functions.firestore
    .document("Appointment requests/{uid}")
    .onCreate(async (snapshot) => {
      const Appointments = snapshot.data();

      const querySnapshot = await db
          .collection("Users")
          .doc(Appointments.CustomerUID)
          .collection("tokens")
          .get();

      const tokens = querySnapshot.docs.map((snap) => snap.id);

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: "Request Approved",
          body: `${Appointments.Company} approved your request! We'll see you on ${Appointments.RequestedDate} at ${Appointments.RequestedTime}`,
          // icon: 'your-icon-url',
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      return fcm.sendToDevice(tokens, payload);
    });

