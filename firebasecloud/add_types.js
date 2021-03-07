(async function () { 
    console.log("Starting")

    const admin = require('firebase-admin');
    console.log("Required admin")
    
    const serviceAccount = require('./service-account.json');
    
    console.log("Loaded service account")
    
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      databaseURL: "https://recipes-8957c.firebaseio.com"
    });
    
    const db = admin.firestore();
    const snapshot = await db.collection('recipes').get();
    snapshot.forEach(async (doc) => {
        console.log(doc.id, '=>', doc.data()['type']);
        const data = doc.data()
        console.log(doc.data())
        data['types'] = [data['type']]
        console.log(data['types'])
        // const res = await db.collection('recipes').doc(doc.id).set(data);
        console.log(res)
    });
    
    console.log("Finished")
 })().catch(e => {
     console.log(e)
 })

