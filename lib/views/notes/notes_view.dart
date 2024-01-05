import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/auth/bloc/auth_bloc.dart';
import 'package:notesapp/services/auth/bloc/auth_events.dart';
import 'package:notesapp/services/cloud/cloud_note.dart';
import 'package:notesapp/services/cloud/firebase_cloud_storage.dart';

import 'package:notesapp/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId =>
      AuthService.firebase().currentUser!.id; //replaced email part with uid

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  // @override //Removed cause we don't need to close...
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //refer appbar class in documentation =====popupmenuitem and popupmenubutton
        title: const Text('Main UI'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    // await AuthService.firebase().logOut();
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                    //Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                )
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: //implicit fallthrough
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<
                    CloudNote>; //basically we're replacing everything with database note with cloud note, uid instead of email...
                return NotesListView(
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    });
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

// Future<bool> showLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Sign Out'),
//         content: const Text("Are you sure you want to sign out?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//             child: const Text('LogOut'),
//           )
//         ],
//       );
//     },
//   ).then((value) =>
//       value ??
//       false); //then is used, logouts can be dismissed without interacting with CTA in android
// }



















// import 'package:flutter/material.dart';
// import 'package:notesapp/services/auth/auth_service.dart';
// import 'package:notesapp/services/crud/notes_service.dart';
// import 'package:notesapp/views/notes/notes_list_view.dart';

// import '../../constants/routes.dart';
// import '../../enums/menu_action.dart';
// import '../../utilities/dialogs/logout_dialog.dart';

// class NotesView extends StatefulWidget {
//   const NotesView({super.key});

//   @override
//   State<NotesView> createState() => _NotesViewState();
// }

// class _NotesViewState extends State<NotesView> {
//   late final NotesService _notesService;
//   String get userEmail => AuthService.firebase().currentUser!.email;

//   @override
//   void initState() {
//     _notesService = NotesService();
//     _notesService.open();
//     super.initState();
//   }

//   // @override //Removed cause we don't need to close...
//   // void dispose() {
//   //   _notesService.close();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         //refer appbar class in documentation =====popupmenuitem and popupmenubutton
//         title: const Text('Main UI'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
//               },
//               icon: const Icon(Icons.add)),
//           PopupMenuButton<MenuAction>(
//             onSelected: (value) async {
//               switch (value) {
//                 case MenuAction.logout:
//                   final shouldLogout = await showLogOutDialog(context);
//                   if (shouldLogout) {
//                     await AuthService.firebase().logOut();
//                     Navigator.of(context)
//                         .pushNamedAndRemoveUntil(loginRoute, (_) => false);
//                   }
//               }
//             },
//             itemBuilder: (context) {
//               return const [
//                 PopupMenuItem<MenuAction>(
//                   value: MenuAction.logout,
//                   child: Text('Log out'),
//                 )
//               ];
//             },
//           )
//         ],
//       ),
//       body: FutureBuilder(
//         future: _notesService.getOrCreateUser(email: userEmail),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return StreamBuilder(
//                 stream: _notesService.allNotes,
//                 builder: (context, snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting: //implicit fallthrough
//                     case ConnectionState.active:
//                       if (snapshot.hasData) {
//                         final allNotes = snapshot.data as List<DatabaseNote>;
//                         return NotesListView(
//                             onTap: (note) {
//                               Navigator.of(context).pushNamed(
//                                 createOrUpdateNoteRoute,
//                                 arguments: note,
//                               );
//                             },
//                             notes: allNotes,
//                             onDeleteNote: (note) async {
//                               await _notesService.deleteNote(id: note.id);
//                             });
//                       } else {
//                         return const CircularProgressIndicator();
//                       }
//                     default:
//                       return const CircularProgressIndicator();
//                   }
//                 },
//               );
//             default:
//               return const CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }

// // Future<bool> showLogOutDialog(BuildContext context) {
// //   return showDialog<bool>(
// //     context: context,
// //     builder: (context) {
// //       return AlertDialog(
// //         title: const Text('Sign Out'),
// //         content: const Text("Are you sure you want to sign out?"),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop(false);
// //             },
// //             child: const Text('Cancel'),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop(true);
// //             },
// //             child: const Text('LogOut'),
// //           )
// //         ],
// //       );
// //     },
// //   ).then((value) =>
// //       value ??
// //       false); //then is used, logouts can be dismissed without interacting with CTA in android
// // }
