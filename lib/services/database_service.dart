import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_4cs/screens/attendance_page.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
//create account
  Future<void> createUserAccount(
      Map<String, dynamic> userData, String userId) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  //add courses
  Future<void> addCourses(
      Map<String, dynamic> courseData, String courseCode) async {
    await FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseCode)
        .set(courseData)
        .catchError((e) {
      print(e.toString());
    });
  }

  //add content to  course
  Future<void> addContentToCourse(
      Map<String, dynamic> contentData, String courseId) async {
    await FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseId)
        .collection("Course-Content")
        .add(contentData)
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }
//create sub content

  Future<void> addSbContentToCourse(
      Map<String, dynamic> subcontentData, String subcontentId) async {
    await FirebaseFirestore.instance
        .collection("Course-Content")
        .doc(subcontentId)
        .collection("Sub-Content")
        .add(subcontentData)
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

//adding pupils to parent
  Future<void> addPupilsToParent(
      Map<String, dynamic> pupilsData, String userId) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Pupils")
        .add(pupilsData)
        .catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

//get all teachers
  getTeacherData() async {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('role', isEqualTo: "Teacher")
        .snapshots();
  }

  //get all parents
  getParentsData() async {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('role', isEqualTo: "Parent")
        .snapshots();
  }

  getTodayAttendance(String date) async {
    return await FirebaseFirestore.instance
        .collection("attendance")
        .where('attendate_date', isEqualTo: date)
        .get();
  }

  //get leave  by child
  getPupilsLeave(String parent_id) async {
    return await FirebaseFirestore.instance
        .collection("Leaves")
        .where('parent_id', isEqualTo: parent_id)
        .limit(3)
        .get();
  }

  getAllLeaveHistory() async {
    return await FirebaseFirestore.instance
        .collection("Leaves")
        .orderBy("leaveDate", descending: true)
        .get();
  }

  getAllMarks(String parent_id) async {
    return await FirebaseFirestore.instance
        .collection("PupilsMarks")
        .where('parent_id', isEqualTo: parent_id)
        .limit(3)
        .get();
  }

  getTodayPupilsAttendance(String date, String Parent_id) async {
    return await FirebaseFirestore.instance
        .collection("attendance")
        .where('attendate_date', isEqualTo: date)
        .where("parent_id", isEqualTo: parent_id)
        .get();
  }

  getAllAttendance() async {
    return await FirebaseFirestore.instance.collection("attendance").get();
  }

  getAllSingleAttendance(String parent_id) async {
    return await FirebaseFirestore.instance
        .collection("attendance")
        .where("parent_id", isEqualTo: parent_id)
        .get();
  }

  //get all courses
  getCoursesData(String teacher_id) async {
    return FirebaseFirestore.instance
        .collection("Courses")
        .where("tid", isEqualTo: teacher_id)
        .snapshots();
  }

  //get all courses
  getCoursesContent(String courseId) async {
    return await FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseId)
        .collection("Course-Content")
        .get();
  }

//view pupils of level
  getAllPupilsData() async {
    return FirebaseFirestore.instance.collectionGroup("Pupils").get();
  }

//parents with their pupils
  getParentChildrens(String userId) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Pupils")
        .get();
  }
}
