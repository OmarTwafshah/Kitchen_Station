import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//هذا الكلاس لقراءة وكتابة وتعديل معلومات السمتخدم وانشاء الحساب والتأكدمن الحساب والتأكد
// من ما اذا كان هذا الحساب مرتبط في المطعم او لا
class AuthController {
  FirebaseAuth? firebaseAuth;
  FirebaseFirestore? firebaseFirestore;
  AuthController() {
    firebaseAuth = FirebaseAuth.instance;
    firebaseFirestore = FirebaseFirestore.instance;
  }

  String? get displayName => firebaseAuth!.currentUser!.displayName;
  String? get uid => firebaseAuth!.currentUser!.uid;
  String? get email => firebaseAuth!.currentUser!.email;

  //Generate id
  Future<void> generateId(String phone) async {
    await firebaseFirestore!.collection("User").doc(uid).set({
      "dateOfBirth": "1/4/1999",
      "email": email,
      "myKitchenId": "No Kitchen",
      "name": displayName,
      "phonenumber": phone,
      "position": "customer",
    });
  }

  Future<bool> checkIfAdmin() async {
    var a = await firebaseFirestore!.collection("User").doc(uid).get();
    String str = a.get("position");

    if (str == "admin") {
      return true;
    }
    return false;
  }

  // check user kitchen
  Future<String> checkIfUserHaveKitchen() async {
    String check = "";
    try {
      var result = await firebaseFirestore!.collection("User").doc(uid).get();
      check = result.get("myKitchenId");
    } catch (e) {
      check = "No Kitchen";
    }

    return check;
  }

  // signin && singup  by email

  Future<bool> signupEmail(String name, String email, String password) async {
    try {
      UserCredential user = await firebaseAuth!
          .createUserWithEmailAndPassword(email: email, password: password);
      await user.user!.updateDisplayName(name);
      // await sharedPreferences!.setBool("sign", true);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signinEmail(String email, String password) async {
    try {
      UserCredential signInResponse = await firebaseAuth!
          .signInWithEmailAndPassword(email: email, password: password);
      // await sharedPreferences!.setBool("sign", true);
      await signInResponse.user!.getIdToken();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkSignin() async {
    try {
      await firebaseAuth!.currentUser!.reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signout() async {
    await firebaseAuth!.signOut();
    // await sharedPreferences!.setBool("sign", false);
  }

  //signin && singup  by google

  //signin && singup  by facebook
}
