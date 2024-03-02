import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student/models/studentmodel.dart';

const String studentCollectionRef = "student";

class StudentProvider extends ChangeNotifier {
  late File _imageFile = File('');
  String? _searchTxt;
  final ImagePicker _imagePicker = ImagePicker();

  File get imageFile => _imageFile;

  Future<void> setImageFileAsync(File imageFile) async {
    await Future.delayed(Duration.zero);
    _imageFile = imageFile;
    notifyListeners();
  }

  Future<void> selectImageFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearImage() {
    _imageFile = File('');
    notifyListeners();
  }

  final _fireStore = FirebaseFirestore.instance;
  late final CollectionReference _studentRef;

  StudentProvider() {
    _studentRef = _fireStore
        .collection(studentCollectionRef)
        .withConverter<StudentModel>(
            fromFirestore: (snapshots, _) =>
                StudentModel.fromJson(snapshots.data()!),
            toFirestore: (student, _) => student.tojson());
  }

  Stream<QuerySnapshot> getStudents() {
    return _studentRef.snapshots();
  }

  void addStudent(StudentModel studentModel) async {
    _studentRef.add(studentModel);
    notifyListeners();
  }

  void updateStudent(String studentId, StudentModel studentModel) {
    _studentRef.doc(studentId).update(studentModel.tojson());
    notifyListeners();
  }

  void deleteStudent(String studentId) {
    _studentRef.doc(studentId).delete();
    notifyListeners();
  }

  Stream<QuerySnapshot> searchStudents(String searchTerm) {
    return _studentRef
        .where('name', isGreaterThanOrEqualTo: searchTerm)
        .where('name', isLessThan: '${searchTerm}z')
        .snapshots();
  }

  String? get searchTxt => _searchTxt;

  void setSearchTxt(String? value) {
    _searchTxt = value;
    notifyListeners();
  }
}













