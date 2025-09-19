import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
// You must define this as a top-level function
Future<void> handlerBackgroundMessage(RemoteMessage message) async {
  print("Title :${message.notification?.title}");
  print("Body :${message.notification?.body}");
  print("Payload :${message.data}");
  await Firebase.initializeApp();
  print('Background message received: ${message.messageId}');
}
class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    // Request notification permission
    await _firebaseMessaging.requestPermission();
    // Get the token for this device
    final fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');
    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);
  }
}
