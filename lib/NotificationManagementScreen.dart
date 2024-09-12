import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationManagementScreen extends StatelessWidget {
  const NotificationManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Management')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/preferences'),
            child: const Text('Update Preferences'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .collection('notifications')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final notification = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(notification['title']),
                      subtitle: Text(notification['body']),
                      trailing:
                          Text(notification['timestamp'].toDate().toString()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
