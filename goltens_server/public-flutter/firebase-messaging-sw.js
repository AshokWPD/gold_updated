importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

const firebaseConfig = {
  apiKey: 'AIzaSyBoxl4PA7pNKc2kBzuHM8HDuket-HacL80',
  appId: '1:480763761159:web:ae7d015450642b3a0010a2',
  messagingSenderId: '480763761159',
  projectId: 'goltens-application',
  authDomain: 'goltens-application.firebaseapp.com',
  storageBucket: 'goltens-application.appspot.com'
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();
