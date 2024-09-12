import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rbuy/NotificationService.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _newsNotifications = false;
  bool _promotionNotifications = false;
  String _frequency = 'Daily';

  Future<void> _savePreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'preferences': {
          'newsNotifications': _newsNotifications,
          'promotionNotifications': _promotionNotifications,
          'frequency': _frequency,
        }
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved')),
      );
    }
    await NotificationService().schedulePersonalizedNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Preferences')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('News Notifications'),
            value: _newsNotifications,
            onChanged: (value) => setState(() => _newsNotifications = value),
          ),
          SwitchListTile(
            title: const Text('Promotion Notifications'),
            value: _promotionNotifications,
            onChanged: (value) =>
                setState(() => _promotionNotifications = value),
          ),
          DropdownButtonFormField<String>(
            value: _frequency,
            items: ['Daily', 'Weekly', 'Monthly']
                .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                .toList(),
            onChanged: (value) => setState(() => _frequency = value!),
            decoration:
                const InputDecoration(labelText: 'Notification Frequency'),
          ),
          ElevatedButton(
            onPressed: _savePreferences,
            child: const Text('Save Preferences'),
          ),
        ],
      ),
    );
  }
}
