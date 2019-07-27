import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_girlies_store/tools/app_methods.dart';
import 'app_data.dart';
import 'app_tools.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class FirebaseMethods implements AppMethods {
  Firestore firestore = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<String> createUserAccount(
      {String fullname, String phone, String email, String password}) async {
    // TODO: implement createUserAccount
    FirebaseUser user;

   // print ('email : $email');
    try {
      user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      /*  } on PlatformException catch (e) {
      //print(e.details);
      return errorMSG(e.details);
    }*/

      // yi 7 Jul 2019 email verification
      await user.sendEmailVerification();

    } catch(error) {
      print(error.toString());
      return error.toString();
    }

    try {
      if (user != null) {
        await firestore.collection(usersData).document(user.uid).setData({
          userID: user.uid,
          acctFullName: fullname,
          userEmail: email,
          userPassword: password,
          phoneNumber: phone
        });

        writeDataLocally(key: userID, value: user.uid);
        writeDataLocally(key: fullname, value: fullname);
        writeDataLocally(key: userEmail, value: userEmail);
        writeDataLocally(key: userPassword, value: password);
      }
      /*} on PlatformException catch (e) {
      //print(e.details);
      return errorMSG(e.details);
    }*/
    } catch (error){
      return error.toString();
    }

    return user == null ? errorMSG("Error") : successfulMSG();
  }

  @override
  Future<String> logginUser({String email, String password}) async {
    // TODO: implement logginUser

    FirebaseUser user;
    try {
      user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (user != null) {
        DocumentSnapshot userInfo = await getUserInfo(user.uid);
        await writeDataLocally(key: userID, value: userInfo[userID]);
        await writeDataLocally(
            key: acctFullName, value: userInfo[acctFullName]);
        await writeDataLocally(key: userEmail, value: userInfo[userEmail]);
        await writeDataLocally(key: phoneNumber, value: userInfo[phoneNumber]);
        await writeDataLocally(key: photoURL, value: userInfo[photoURL]);
        await writeBoolDataLocally(key: loggedIN, value: true);

        print(userInfo[userEmail]);
      }
      /*   } on PlatformException catch (e) {
      //print(e.details);
      return errorMSG(e.details);
    }*/
    } catch (error) {
      return error.toString();
    }


    // yohan added 07 Jul 2019
    print ('email verified : $user.isEmailVerified');
    if (await !user.isEmailVerified) user = null;



    return user == null ? errorMSG("Email is not verified, please check your registered email") : successfulMSG();
  }


  // yohan added
  @override
  Future<String> resetPassword({String email}) async {
    try {
      print("go in reset password");
      await auth.sendPasswordResetEmail(email: email);
    } catch (error){
      //print (error);

     // if (error )


      return error.toString();
    }
    /*} on PlatformException catch(e) {
      print ('error *****************************************************************');
         return errorMSG(e.details);
    }*/
    return ("success");
  }

  Future<bool> complete() async {
    return true;
  }

  Future<bool> notComplete() async {
    return false;
  }

  Future<String> successfulMSG() async {
    return successful;
  }

  Future<String> errorMSG(String e) async {
    return e;
  }

  @override
  Future<bool> logOutUser() async {
    // TODO: implement logOutUser
    await auth.signOut();
    await clearDataLocally();

    return complete();
  }

  @override
  Future<DocumentSnapshot> getUserInfo(String userid) async {
    // TODO: implement getUserInfo
     return await firestore.collection(usersData).document(userid).get();
  }
}
