import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesapp/services/cloud/cloud_note.dart';
import 'package:notesapp/services/cloud/cloud_storage_constants.dart';
import 'package:notesapp/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared; //creating a snigleton

  final notes = FirebaseFirestore.instance
      .collection('notes'); // the notes collection already has to be created

  // Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
  //     notes.snapshots().map(
  //           (event) => event.docs
  //               .map((doc) => CloudNote.fromSnapShot(doc))
  //               .where((note) => note.ownerUserId == ownerUserId),
  //         );

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map(
          (event) => event.docs.map((doc) => CloudNote.fromSnapShot(doc)),
        );
    return allNotes;
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  // Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
  //   try {
  //     return await notes
  //         .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
  //         .get()
  //         .then(
  //             (value) => value.docs.map((doc) => CloudNote.fromSnapShot(doc)));
  //   } catch (e) {
  //     throw CouldNotGetAllNotesException();
  //   }
  // }
}
