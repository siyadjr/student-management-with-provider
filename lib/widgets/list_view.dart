import 'package:flutter/material.dart';
import 'package:student_management_provider/Constant/constant_colors.dart';
import 'package:student_management_provider/Database/student_data_base.dart';
import 'package:student_management_provider/Model/student_model.dart';
import 'package:student_management_provider/Provider/studentProvider.dart';
import 'package:student_management_provider/screens/edit_students.dart';
import 'package:student_management_provider/screens/student_details.dart';

class StudentListView extends StatelessWidget {
  const StudentListView({
    super.key,
    required List<StudentModel> filteredStudentList,
  }) : _filteredStudentList = filteredStudentList;

  final List<StudentModel> _filteredStudentList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _filteredStudentList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => StudentDetailsPage(
                    student: _filteredStudentList[index],
                  ),
                ),
              );
            },
            title: Text(
              _filteredStudentList[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: CircleAvatar(
              backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
              child: Text(
                _filteredStudentList[index].name[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>EditStudents(student: _filteredStudentList[index])));
                } else if (value == 'delete') {
                  _showDeleteConfirmationDialog(
                      context, _filteredStudentList[index]);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, StudentModel student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${student.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the delete function from the database provider
                deleteStudent(student);
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void deleteStudent(StudentModel student) {
    StudentProvider studentProviderObj = StudentProvider();
    studentProviderObj.deleteStudent(student);
  }
}
