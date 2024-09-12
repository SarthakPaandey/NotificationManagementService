# Personalized Notification App

This Flutter application demonstrates the implementation of personalized push notifications based on user preferences using OneSignal.

## Setup Instructions

1. Clone this repository.
2. Run `flutter pub get` to install dependencies.
3. Set up a Firebase project and add your `google-services.json` file to `android/app/`.
4. Set up a OneSignal account and create a new app.
5. Replace "YOUR_ONESIGNAL_APP_ID" in `main.dart` with your actual OneSignal App ID.
6. Run the app using `flutter run`.

## Testing Push Notifications

1. Register a new user in the app.
2. Set notification preferences.
3. Use the OneSignal dashboard to send a test notification.
4. Observe the personalized notification in the app.

## Architecture and Design Choices

- Firebase Authentication is used for user management.
- Cloud Firestore stores user preferences and notification history.
- OneSignal handles push notifications.
- The app uses a simple provider pattern for state management.
- Notifications are scheduled and sent using OneSignal's API.

