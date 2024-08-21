# business_manager

This is a Flutter application for managing inventory and sales, integrated with Firebase for authentication and Firestore for database management. The app allows users to add, view, update, and delete inventory items, manage sales, and view saved items. The app also features Firebase authentication for secure access.

Features
Inventory Management: Add, view, update, and delete inventory items.
Sales Management: Record sales and automatically update the inventory.
View Saved Items: View a list of all saved inventory items.
Authentication: Secure login and signup using Firebase Authentication.
Firestore Integration: Store and retrieve data using Firestore.
Navigation: Easy navigation between different parts of the app via a home screen.

Getting Started
Prerequisites

Flutter: You must have Flutter installed on your machine. Follow the official Flutter installation guide if you haven't set it up yet.
Firebase Project: You need a Firebase project with Firestore and Authentication enabled. Follow the official Firebase setup guide to set it up.

Installation

Clone the Repository:
git clone https://github.com/your-username/inventory-sales-management.git
cd inventory-sales-management

Install Dependencies:
flutter pub get

Set Up Firebase:

Create a Firebase project in the Firebase console.
Add an Android and/or iOS app to your Firebase project.
Download the google-services.json (for Android) or GoogleService-Info.plist (for iOS) file and place it in the appropriate directory in your Flutter project:
Android: android/app/google-services.json
iOS: ios/Runner/GoogleService-Info.plist
Follow the official Firebase setup guide to properly integrate Firebase with your Flutter app.

Update Firestore Rules:
Go to the Firestore Database section in the Firebase console.
Click on Rules and replace the default rules with the following:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write access to all documents for authenticated users
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}

Click Publish to save the rules.

Running the App
Run the App:
flutter run

Login/Signup:
On the initial screen, sign up or log in using an email and password.
After successful authentication, you will be navigated to the Home Screen.

Navigating the App:
From the Home Screen, you can navigate to:
Inventory Management: Add, update, or delete inventory items.
Sales Management: Record sales and update inventory accordingly.
View Saved Items: View a list of saved inventory items.

Project Structure
lib/
main.dart: Entry point of the app.
screens/
login_screen.dart: Handles user login.
signup_screen.dart: Handles user signup.
home_screen.dart: Main navigation screen after login.
inventory_screen.dart: Manages inventory items.
sales_screen.dart: Manages sales records.
view_items_screen.dart: Displays saved inventory items.

Troubleshooting
Permission Denied Error: Ensure that the Firestore rules are correctly set up, and the user is authenticated before trying to access Firestore.
Firebase Initialization Error: Ensure Firebase is initialized in main.dart and that the necessary google-services.json or GoogleService-Info.plist files are in place.

Future Improvements
Role-Based Access Control: Implement different user roles with varying permissions.
Enhanced UI/UX: Improve the design and add animations for a better user experience.
Offline Support: Add offline capabilities for managing inventory and sales without an active internet connection.

Contributing
If you wish to contribute to this project, please fork the repository and submit a pull request.

License
This project is licensed under the MIT License - see the LICENSE file for details.
