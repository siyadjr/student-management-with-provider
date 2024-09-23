import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management_provider/Constant/constant_colors.dart';
import 'package:student_management_provider/Provider/studentProvider.dart';
import 'package:student_management_provider/Model/student_model.dart';
import 'package:student_management_provider/screens/add_student.dart';
import 'package:student_management_provider/screens/screen_login.dart';
import 'package:student_management_provider/widgets/grid_view.dart';
import 'package:student_management_provider/widgets/list_view.dart';
import 'package:provider/provider.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    // Load students once when the provider is accessed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      studentProvider.loadStudents();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management Provider',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndViewOptions(context),
          _buildStudentListView(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => const AddStudent()));
        },
        backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchAndViewOptions(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: ConstantColors.getColor(ColorOptions.mainColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search Student',
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              studentProvider.setSearchQuery(value);
            },
          ),
          const SizedBox(height: 16),
          DropdownButton<ViewType>(
            value: studentProvider.currentView,
            onChanged: (ViewType? newValue) {
              if (newValue != null) {
                studentProvider.setCurrentView(newValue);
              }
            },
            items: ViewType.values.map((ViewType type) {
              return DropdownMenuItem<ViewType>(
                value: type,
                child: Row(
                  children: [
                    Icon(
                      type == ViewType.list ? Icons.list : Icons.grid_view,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      type == ViewType.list ? 'List' : 'Grid',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }).toList(),
            dropdownColor: ConstantColors.getColor(ColorOptions.mainColor),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            underline: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListView(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    List<StudentModel> filteredStudentList = studentProvider.filteredStudents;

    if (filteredStudentList.isEmpty) {
      return const Center(child: Text('No students found'));
    }

    return Expanded(
      child: studentProvider.currentView == ViewType.list
          ? StudentListView(filteredStudentList: filteredStudentList)
          : GridViewStudents(filteredStudentList: filteredStudentList),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool('userlogged', false);
    await sharedPref.setBool('signed', false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const ScreenLogin()),
      (route) => false,
    );
  }
}
