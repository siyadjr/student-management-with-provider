

import 'package:flutter/material.dart';
import 'package:student_management_provider/Constant/constant_colors.dart';


import '../Model/student_model.dart';

class GridViewStudents extends StatelessWidget {
  const GridViewStudents({
    super.key,
    required List<StudentModel> filteredStudentList,
  }) : _filteredStudentList = filteredStudentList;

  final List<StudentModel> _filteredStudentList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _filteredStudentList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: ConstantColors.getColor(
                      ColorOptions.mainColor),
                  child: Text(_filteredStudentList[index].name[0],
                      style: const TextStyle(
                          fontSize: 24, color: Colors.white)),
                ),
                const SizedBox(height: 8),
                Text(
                  _filteredStudentList[index].name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      );
  }
}
