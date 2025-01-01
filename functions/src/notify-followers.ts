// // Batch notifications with more efficient processing
// const notificationTasks = friendIds.map(async (friendId: string) => {
//   // Fetch friend's token
//   const tokenDoc = await admin.firestore()
//     .collection('user_tokens')
//     .doc(friendId)
//     .get();

//   const friendToken = tokenDoc.data()?.token;

//   if (friendToken) {
//     const message = {
//       notification: {
//         title: 'New Checkin',
//         body: 'Your friend added a new entry!',
//       },
//       token: friendToken,
//       data: {
//         type: 'new_entry',
//         venueId: venueId,
//         checkingInId: newCheckin.uid,
//       },
//     };

//     try {
//       await admin.messaging().send(message);
//       console.log(`Notification sent to friend: ${friendId}`);
//     } catch (error) {
//       console.error('Messaging error:', error);
//     }
//   }
// });

// // Wait for all notifications to complete
// await Promise.all(notificationTasks);
