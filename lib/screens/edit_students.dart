import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management_provider/Model/student_model.dart';
import 'package:student_management_provider/Provider/studentProvider.dart';
import '../Constant/constant_colors.dart';

class EditStudents extends StatefulWidget {
  final StudentModel student;

  const EditStudents({super.key, required this.student});

  @override
  _EditStudentsState createState() => _EditStudentsState();
}

class _EditStudentsState extends State<EditStudents> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _placeController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with student data
    _nameController = TextEditingController(text: widget.student.name);
    _ageController = TextEditingController(text: widget.student.age);
    _phoneController = TextEditingController(text: widget.student.phone);
    _placeController = TextEditingController(text: widget.student.place);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final newStudentdata = StudentModel(
        name: _nameController.text,
        age: _ageController.text,
        phone: _phoneController.text,
        place: _placeController.text,
        photo: widget.student.photo,
      );
      final provider = Provider.of<StudentProvider>(context, listen: false);
      provider.updateStudent(newStudentdata, widget.student).then((_) {
        Navigator.pop(context); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display student photo
              widget.student.photo != null
                  ? Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(widget.student.photo!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(
                      height: 250,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'lib/assets/default_student_avatar.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              _buildTextField(Icons.person, 'Name', _nameController),
              _buildTextField(
                  Icons.cake, 'Age', _ageController, TextInputType.number),
              _buildTextField(
                  Icons.phone, 'Phone', _phoneController, TextInputType.phone),
              _buildTextField(Icons.location_on, 'Place', _placeController),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        ConstantColors.getColor(ColorOptions.mainColor),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      IconData icon, String label, TextEditingController controller,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          icon: Icon(icon,
              color: ConstantColors.getColor(ColorOptions.mainColor)),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
