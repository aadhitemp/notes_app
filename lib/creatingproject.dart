//flutter create --org xxx.domain appname
//use the above syntax to register app
//not using the identifier adds some steps in the end...that's all...
/*in Terminal
  flutter pub add firebase_core
  flutter pud add firebase_auth
  flutter pub add cloud_firestore
  flutter pub add firebase_analytics

  iOS developer account, applying for that...5:50:57
  Certificates and Profiles, create them...I don't kow...
  Devlopment certificate and production certficate is needed
  create app identifier
  Device UUID..
  remove automatic signing or something..

 */
//===================Firebase Backed=============
/* dart pub global activate flutterfire_cli //that's the thing which needs npm and node//
this things allows us to interact with firebase from terminal flutterfire_cli
flutterfire configure     use that to create firebase projects from terminal
*/
//anonymous users
//gpg and ssh key in git and setting it up in github
//git tag ""
//git push --tags
//named routes and anonymous routes
//the user has to login again for firebbase instance to know, he has logged out
//test drived development TDD flutter
//flutter pub add test --dev 
//What are mocks
//What are tests and test groups
//flutter pub add sqflite
//flutter pub add path_provider
//flutter pub add path
//flutter test test/auth_test.dart
//=================
//Change minsdkversion to 19 in android build gradle /project/app/build.gradle
//enable multidexing...
//=====================
// rules_version = '2';

// service cloud.firestore {
//   match /databases/{database}/documents {

//     // This rule allows anyone with your Firestore database reference to view, edit,
//     // and delete all data in your Firestore database. It is useful for getting
//     // started, but it is configured to expire after 30 days because it
//     // leaves your app open to attackers. At that time, all client
//     // requests to your Firestore database will be denied.
//     //
//     // Make sure to write security rules for your app before that time, or else
//     // all client requests to your Firestore database will be denied until you Update
//     // your rules
//     match /{document=**} {
//       allow read, write: if request.time < timestamp.date(2023, 9, 20);//////////////================request.auth!=null;
//     }
//   }
// }===============
//https://firebase.flutter.dev/docs/firestore/usage
//https://firebase.google.com/docs/firestore/quickstart
//https://docs.flutter.dev/resources/architectural-overview
//collections are like table:...documents are like schema??
//we get the uid.../firebase collection can exist without document
//we use a plugin to share notes 'share-plus' plugin
//-------plugin is much bigger than package I guess...
//flutter pub add share_plus
//Sometimes we need to clean worksapce or something when we add need dependencies...
//flutter clean
//flutter pub get
//flutter pub add flutter_bloc
//flutter pub add bloc
//flutter pub add equatable  //
//overlays....
//await Future.delayed(const Duration(seconds: 3)); //dealying stuff to see things like loading screens
//flutter pub add flutter_launcher_icon //read the documentatin for dependency
//dart run flutter_launcher_icons
// in info.plist change the CFBundleDisplayName to the name of app name used instead of notesapp .....this is for ios
//in androidmanifest.xml in android/app/src/main
//ios splash screen implementation requires mac, or so he said
//create new firebase rules
//localization in flutter //creating multiple languages and configurations
//flutter pub add intl
//arb...application resource bundles