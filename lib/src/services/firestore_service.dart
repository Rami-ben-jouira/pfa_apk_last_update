import 'package:adhd_helper/src/models/Breathing.dart';
import 'package:adhd_helper/src/models/activites.dart';
import 'package:adhd_helper/src/models/child.dart';
import 'package:adhd_helper/src/models/conner_quiz.dart';
import 'package:adhd_helper/src/models/conversation.dart';
import 'package:adhd_helper/src/models/emotion_wave.dart';
import 'package:adhd_helper/src/models/emotions.dart';
import 'package:adhd_helper/src/models/message.dart';
import 'package:adhd_helper/src/models/notebook.dart';
import 'package:adhd_helper/src/models/questionnaire.dart';
import 'package:adhd_helper/src/models/routines.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adhd_helper/src/models/user.dart';

import '../models/doctor.dart';
import 'auth_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<bool> doesUserProfileExist() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser!.uid;
      final DocumentSnapshot userProfileSnapshot =
          await _firestore.collection('users').doc(uid).get();

      // Check if the document exists.
      if (userProfileSnapshot.exists) {
        return true; // User profile exists.
      } else {
        return false; // User profile does not exist.
      }
    } catch (e) {
      print('Error checking user profile: $e');
      return false; // An error occurred, consider handling it accordingly.
    }
  }

  void saveUserProfile(Map<String, dynamic> userProfile) async {
    try {
      await _firestore.collection('users').add(userProfile);

      // Profile data saved successfully.
      // You can also handle success and error cases here.
    } catch (e) {
      print('Error saving profile: $e');
      // Handle the error.
    }
  }

  Future<UserProfile?> getProfileByuid(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique, we'll just take the first document found.
        var profileData = querySnapshot.docs[0].data() as Map<String, dynamic>;
        UserProfile user = UserProfile.fromMap(profileData);

        return user;
      } else {
        // Handle the case when the profile doesn't exist for the given email.
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the database query.
      print('Error getting profile by email: $e');
      return null;
    }
  }

  Future<void> deleteProfileByUid(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique, we'll just delete the first document found.
        var documentId = querySnapshot.docs[0].id;
        await _firestore.collection('users').doc(documentId).delete();
      } else {
        // Handle the case when the profile doesn't exist for the given email.
      }
    } catch (e) {
      // Handle any errors that occur during the delete operation.
      print('Error deleting profile by email: $e');
    }
  }

  Future<void> updateProfileByUid(
      String uid, Map<String, dynamic> updatedData) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique, we'll just update the first document found.
        var documentId = querySnapshot.docs[0].id;
        await _firestore
            .collection('users')
            .doc(documentId)
            .update(updatedData);
      } else {
        // Handle the case when the profile doesn't exist for the given email.
      }
    } catch (e) {
      // Handle any errors that occur during the update operation.
      print('Error modifying profile by email: $e');
    }
  }

  Future<void> updatefieledProfileByUid(String field, String data) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique, we'll just update the first document found.
        var documentId = querySnapshot.docs[0].id;
        await _firestore
            .collection('users')
            .doc(documentId)
            .update({field: data});
      } else {
        // Handle the case when the profile doesn't exist for the given email.
      }
    } catch (e) {
      // Handle any errors that occur during the update operation.
      print('Error modifying profile by email: $e');
    }
  }

  Future<List<String>> getChildrenNames() async {
    List<String> childrenNames = [];
    try {
      String? uid = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('childs')
          .where('parentUid', isEqualTo: uid)
          .get();

      for (var doc in snapshot.docs) {
        String childName = doc.data()['name'] ?? '';
        childrenNames.add(childName);
      }
    } catch (e) {
      print('Error getting children names: $e');
    }
    return childrenNames;
  }

  Future<String?> getCurrentChildId() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var profileData = querySnapshot.docs[0].data() as Map<String, dynamic>;
        UserProfile user = UserProfile.fromMap(profileData);

        return user.currentChildId;
      } else {
        // Handle the case when the profile doesn't exist for the given email.
        return null;
      }
    } catch (e) {
      print('Error getting current child ID: $e');
    }
    return null;
  }

  Future<String?> getChildrenidByName(String childname) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('childs')
          .where('parentUid', isEqualTo: uid)
          .where('name', isEqualTo: childname)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      }
    } catch (e) {
      print('Error getting child ID: $e');
    }
    return null;
  }

  Future<void> updateCurrentChildId(String childname) async {
    try {
      String? childid = await getChildrenidByName(childname);
      await updatefieledProfileByUid("currentChildId", childid!);
    } catch (e) {
      print('Error updating current child ID: $e');
    }
  }

  Future<void> saveChildProfile(Map<String, dynamic> child) async {
    try {
      DocumentReference childDocRef =
          await _firestore.collection('childs').add(child);

      // Update the parent document with the child's ID
      String? uid = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique, we'll just update the first document found.
        var documentId = querySnapshot.docs[0].id;
        await _firestore.collection('users').doc(documentId).update({
          'childrenIds': FieldValue.arrayUnion([childDocRef.id])
        });
      } else {
        // Handle the case when the profile doesn't exist for the given email.
      }
    } catch (e) {
      // Handle any errors that occur during the update operation.
      print('Error modifying profile by email: $e');
    }
  }

  Future<ChildProfil?> getChildProfileByUid(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('childs')
          .where('parentUid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var childProfil = querySnapshot.docs[0].data() as Map<String, dynamic>;
        ChildProfil child = ChildProfil.fromMap(childProfil);

        return child;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting child profil by uid: $e');
      return null;
    }
  }

  // Create a new Questionnaire
  Future<void> createQuestionnaire(Questionnaire questionnaire) async {
    await _firestore.collection('questionnaires').add(questionnaire.toMap());
  }

  // Update an existing Questionnaire based on user UID
  Future<void> updateQuestionnaire(
      String userUid, Questionnaire questionnaire) async {
    final querySnapshot = await _firestore
        .collection('questionnaires')
        .where('uid', isEqualTo: userUid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await _firestore
          .collection('questionnaires')
          .doc(docId)
          .update(questionnaire.toMap());
    }
  }

  // Delete a Questionnaire based on user UID
  Future<void> deleteQuestionnaire(String userUid) async {
    final querySnapshot = await _firestore
        .collection('questionnaires')
        .where('uid', isEqualTo: userUid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await _firestore.collection('questionnaires').doc(docId).delete();
    }
  }

  // Get a Questionnaire by user UID
  Future<Questionnaire?> getQuestionnaireByUid(String userUid) async {
    final querySnapshot = await _firestore
        .collection('questionnaires')
        .where('uid', isEqualTo: userUid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      final docSnapshot =
          await _firestore.collection('questionnaires').doc(docId).get();
      return Questionnaire.fromMap(docSnapshot.data() as Map<String, dynamic>);
    }

    return null;
  }

  Future<void> saveCPTTest(Map<String, dynamic> testData) async {
    try {
      String userUid = _authService.getCurrentUser()!.uid;
      QuerySnapshot testDocuments = await _firestore
          .collection('CPTTest')
          .where('uid', isEqualTo: userUid)
          .get();

      int nextTestNumber;

      if (testDocuments.docs.isEmpty) {
        // No existing tests for the user, this is the first test
        nextTestNumber = 1;
      } else {
        // Determine the test number for the new test based on the existing tests
        nextTestNumber = testDocuments.docs.length + 1;
      }
      await _firestore.collection("CPTTest").add({
        'uid': userUid,
        'testNumber': nextTestNumber,
        'testDate': DateTime.now(),
        'testData': testData,
      });
    } catch (e) {
      print('Error saving test: $e');
    }
  }

  Future<void> updateCPTTest(
      String testId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection("CPTTest").doc(testId).update(updatedData);
    } catch (e) {
      print('Error updating test: $e');
    }
  }

  Future<List<Doctor>> fetchDoctors() async {
    try {
      // Reference to the "doctors" collection in Firestore
      CollectionReference doctorsCollection = _firestore.collection('doctors');

      // Get the documents in the "doctors" collection
      QuerySnapshot querySnapshot = await doctorsCollection.get();

      // Iterate through the documents and convert them to Doctor objects
      List<Doctor> doctors = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Doctor.fromMap(data);
      }).toList();

      return doctors;
    } catch (e) {
      // Handle any errors here, such as network issues or Firestore errors.
      print("Error fetching doctors: $e");
      return [];
    }
  }

  Future<String?> getDoctorUidFromUser(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique, we'll just take the first document found.
        var profileData = querySnapshot.docs[0].data() as Map<String, dynamic>;
        UserProfile user = UserProfile.fromMap(profileData);
        return user.doctorUid;
      } else {
        // Handle the case when the profile doesn't exist for the given email.
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the database query.
      print('Error getting profile by email: $e');
      return null;
    }
  }

  Future<void> saveDoctorUidInUserProfilAndUserProfilInDoctorProfil(
      String useruid, String doctoruid) async {
    try {
      UserProfile? user = await getProfileByuid(useruid);
      String? olddoctoruid = user?.doctorUid;
      user!.doctorUid = doctoruid;
      String patientName = user.firstName;
      updateProfileByUid(useruid, user.toMap());
      if (olddoctoruid != null) {
        deleteUserFromOldDoctor(useruid, olddoctoruid);
      }

      Doctor? doctor = await getDoctorbyUId(doctoruid);

      ChildProfil? child = await getChildProfileByUid(useruid);

      String childName = child!.name;
      String childSex = child.gender;
      int childAge = child.age;

      String? childId = await getCurrentChildId();

      // Create a new client
      Map<String, dynamic> newClient = {
        "childID": childId,
        "parentID": useruid,
        "isconfirmed": true,
        "parent_name": patientName,
        "childName": childName,
        "childSex": childSex,
        "childAge": childAge,
      };

      String nextIndex = nextKey(doctor?.confirmedPatients);
      doctor!.confirmedPatients[nextIndex] = newClient;

      updateDoctorByUid(doctoruid, doctor.toMap());
    } catch (e) {
      // Handle any errors that occur during the database query.
      print('Error saveDoctorUidInUserProfil: $e');
      return;
    }
  }

  Future<Doctor?> getDoctorbyUId(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('doctors')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique, we'll just take the first document found.
        var doctor = querySnapshot.docs[0].data() as Map<String, dynamic>;
        Doctor doc = Doctor.fromMap(doctor);

        return doc;
      } else {
        // Handle the case when the profile doesn't exist for the given email.
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the database query.
      print('Error getting profile by uid: $e');
      return null;
    }
  }

  Future<void> updateDoctorByUid(
      String uid, Map<String, dynamic> updatedData) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('doctors')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique, we'll just update the first document found.
        var documentId = querySnapshot.docs[0].id;
        await _firestore
            .collection('doctors')
            .doc(documentId)
            .update(updatedData);
      } else {
        // Handle the case when the profile doesn't exist for the given email.
      }
    } catch (e) {
      // Handle any errors that occur during the update operation.
      print('Error modifying profile by email: $e');
    }
  }

  Future<void> deleteUserFromOldDoctor(
      String useruid, String olddoctoruid) async {
    Doctor? doctor = await getDoctorbyUId(olddoctoruid);
    Map<String, dynamic>? confirmedPatients = doctor!.confirmedPatients;
    confirmedPatients.removeWhere((key, value) => value["uid"] == useruid);
    doctor.confirmedPatients = confirmedPatients;
    updateDoctorByUid(olddoctoruid, doctor.toMap());
  }

  String nextKey(Map<String, dynamic>? patients) {
    if (patients != null && patients.isNotEmpty) {
      // Convert keys to integers and find the maximum
      List<int> keysAsInt = patients.keys.map(int.parse).toList();
      int maxKeyAsInt = keysAsInt
          .reduce((value, element) => value > element ? value : element);
      maxKeyAsInt++;
      // Convert the maximum key back to a string
      String maxKey = maxKeyAsInt.toString();

      return maxKey;
    } else {
      int maxKeyAsInt = 0;
      String maxKey = maxKeyAsInt.toString();
      return maxKey;
    }
  }

  Future<List<Message>> getMessages(String userUid) async {
    try {
      final querySnapshot = await _firestore
          .collection('messages')
          .where('uid', isEqualTo: userUid)
          .get();

      // Iterate through the documents and convert them to Doctor objects
      List<Message> messages = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Message.fromMap(data);
      }).toList();

      return messages;
    } catch (e) {
      // Handle any errors here, such as network issues or Firestore errors.
      print("Error getMessages : $e");
      return [];
    }
  }

  Future<bool> haveQuestionnaire(String userUid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('questionnaires')
          .where('uid', isEqualTo: userUid)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print("Error in getQuestionnaire: $e");
      return false; // Return false in case of any error
    }
  }

  Future<bool> haveDoctorUidFromUser(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique, we'll just take the first document found.
        var profileData = querySnapshot.docs[0].data() as Map<String, dynamic>;
        UserProfile user = UserProfile.fromMap(profileData);
        var doctor = user.doctorUid;
        if (doctor!.isEmpty) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      // Handle any errors that occur during the database query.
      print('Error getting profile by email: $e');
      return false;
    }
  }

  void addConnerQuiz(ConnerQuiz conners) async {
    await _firestore.collection('connerquiz').add(conners.toMap());
  }

  void addNotebook(NoteBook noteBook) async {
    await _firestore.collection('Activites_Cognitives').add(noteBook.toMap());
  }

  void addRoutine(Routines routine) async {
    await _firestore.collection('Activites_Cognitives').add(routine.toMap());
  }

  void addActivite(Activites activites) async {
    await _firestore
        .collection('Activites_comportementales')
        .add(activites.toMap());
  }

  void addEmotions(Emotions emotions) async {
    await _firestore
        .collection('activites_emotionnelles')
        .add(emotions.toMap());
  }

  void addEmotionWave(EmotionWave emotionWave) async {
    await _firestore
        .collection('activites_emotionnelles')
        .add(emotionWave.toMap());
  }

  void addBreathing(Breathing breathing) async {
    await _firestore
        .collection('activites_emotionnelles')
        .add(breathing.toMap());
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////

  // Create a new Conversation in Firestore
  Future<void> createConversation(Conversation conversation) async {
    try {
      await _firestore
          .collection('conversations')
          .doc(conversation.idConversation)
          .set(conversation.toMap());
    } catch (e) {
      print('Error creating conversation: $e');
      throw e;
    }
  }

  // Delete a Conversation
  static Future<void> deleteConversation(String conversationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .delete();
    } catch (e) {
      print('Error deleting conversation: $e');
      throw e;
    }
  }

  // Get a Conversation by ID
  static Future<Conversation?> getConversationById(
      String conversationId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .get();

      if (docSnapshot.exists) {
        return Conversation.fromMap(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting conversation: $e');
      return null;
    }
  }

  // Get all Conversations for a specific child
  Future<List<Conversation>> getUserConversations(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('conversations')
          .where('parentId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => Conversation.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting user conversations: $e');
      return [];
    }
  }

  // Add a message to the conversation
  Future<void> addMessageToConversation(
      String conversationId, String message) async {
    try {
      await _firestore.collection('conversations').doc(conversationId).update({
        'chatMessages': FieldValue.arrayUnion([message])
      });
    } catch (e) {
      print('Error adding message to conversation: $e');
      throw e;
    }
  }

  // Update an existing Conversation
  Future<void> updateConversation(
      String conversationId, Conversation conversation) async {
    try {
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .update(conversation.toMap());
    } catch (e) {
      print('Error updating conversation: $e');
      throw e;
    }
  }

  // Future<List<String>> fetchUserIdsFromFirestore() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firestore.collection('users').get();
  //     List<String> userIds = querySnapshot.docs
  //         .map((doc) => doc.data()['uid'] as String)
  //         .toList();
  //     return userIds;
  //   } catch (e) {
  //     print('Error fetching user IDs: $e');
  //     return [];
  //   }
  // }
}
