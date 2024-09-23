import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student_management_provider/Model/student_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum ViewType { list, grid }

class StudentProvider with ChangeNotifier {
  List<StudentModel> _students = [];
  List<StudentModel> get students => _students;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  ViewType _currentView = ViewType.list;
  ViewType get currentView => _currentView;

  List<StudentModel> get filteredStudents => _students
      .where((student) =>
          student.name.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  File? _image;
  bool _isDefaultSelected = true;

  // Getters
  File? get image => _image;
  bool get isDefaultSelected => _isDefaultSelected;

  Future<void> getImage() async {
    // Your image picking logic...
  }

  void selectDefaultImage() {
    // Your default image selection logic...
  }

  void clearFields() {
    nameController.clear();
    ageController.clear();
    phoneController.clear();
    placeController.clear();
    selectDefaultImage(); // Reset to default image
    notifyListeners();
  }

  Future<void> loadStudents() async {
    final studentBox = Hive.box<StudentModel>('students');
    _students = studentBox.values.toList();
    notifyListeners();
  }

  // Add a new student to Hive and notify listeners
  Future<void> addStudent(StudentModel student) async {
    final studentBox = Hive.box<StudentModel>('students');
    await studentBox.add(student);
    await loadStudents(); // Refresh the list
  }

  // Delete a student from Hive and notify listeners
  Future<void> deleteStudent(StudentModel student) async {
    final studentBox = Hive.box<StudentModel>('students');
    int index =
        studentBox.values.toList().indexWhere((s) => s.name == student.name);

    if (index != -1) {
      await studentBox.deleteAt(index);
      await loadStudents();
    }
  }

  Future<void> updateStudent(StudentModel newstudent,StudentModel student) async {
    final studentBox = Hive.box<StudentModel>('students');
    int index = studentBox.values.toList().indexWhere((s) =>
        s.name.trim().toLowerCase() == student.name.trim().toLowerCase());

    log('Found index: $index for student: ${student.name}');

    if (index != -1) {
      await studentBox.putAt(index, newstudent);
      await loadStudents(); // Refresh the list
      notifyListeners();
    } else {
      log('Student not found for update: ${newstudent.name}');
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCurrentView(ViewType view) {
    _currentView = view;
    notifyListeners();
  }
}
