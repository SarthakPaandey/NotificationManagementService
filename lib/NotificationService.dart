import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationService {
  Future<void> init() async {
    // OneSignal is already initialized in main.dart
  }

  Future<void> schedulePersonalizedNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final preferences = userDoc.data()?['preferences'] ?? {};

    if (preferences['newsNotifications'] &&
        preferences['frequency'] == 'Daily') {
      await _scheduleNewsNotification();
    }

    if (preferences['promotionNotifications'] &&
        preferences['frequency'] == 'Daily') {
      await _schedulePromotionNotification();
    }
  }

  Future<void> _scheduleNewsNotification() async {
    await OneSignal.shared.postNotification(OSCreateNotification(
      content: "Here's your daily news digest!",
      heading: "Daily News Update",
      sendAfter: DateTime.now().add(const Duration(days: 1)),
    ));
  }

  Future<void> _schedulePromotionNotification() async {
    await OneSignal.shared.postNotification(OSCreateNotification(
      content: "Check out today's special offers!",
      heading: "Daily Promotion",
      sendAfter: DateTime.now().add(const Duration(days: 1)),
    ));
  }
}
