import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/bouncing_entrances/bounce_in_up.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_down.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_left.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_right.dart';

import 'package:provider/provider.dart';
import 'package:student_management_provider/Constant/constant_colors.dart';
import 'package:student_management_provider/Model/student_model.dart';
import 'package:student_management_provider/Provider/studentProvider.dart';

class AddStudent extends StatelessWidget {
  const AddStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Add New Student'),
        backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<StudentProvider>(
            builder: (context, provider, child) {
              return Form(
                key: provider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildImageCard(provider),
                          _buildDefaultImageCard(provider),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInLeft(child: _buildInputCard(Icons.person, 'Name', provider.nameController)),
                    FadeInRight(child: _buildInputCard(Icons.cake, 'Age', provider.ageController, TextInputType.number)),
                    FadeInLeft(child: _buildInputCard(Icons.phone, 'Phone', provider.phoneController, TextInputType.phone)),
                    FadeInRight(child: _buildInputCard(Icons.place, 'Place', provider.placeController)),
                    const SizedBox(height: 24),
                    Center(
                      child: BounceInUp(
                        child: ElevatedButton(
                          onPressed: () {
                            if (provider.formKey.currentState!.validate()) {
                              addStudentData(provider, context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Add Student', style: TextStyle(fontSize: 12, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(StudentProvider provider) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: GestureDetector(
        onTap: () => provider.getImage(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
                backgroundImage: provider.image != null ? FileImage(provider.image!) : null,
                child: provider.image == null ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white) : null,
              ),
              const SizedBox(height: 16),
              Text(
                provider.image != null ? 'Tap to change photo' : 'Tap to add photo',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultImageCard(StudentProvider provider) {
    return GestureDetector(
      onTap: () => provider.selectDefaultImage(),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.teal,
                    backgroundImage: AssetImage('lib/assets/default_student_avatar.jpeg'),
                  ),
                  const SizedBox(height: 16),
                  Text('Default Image', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            if (provider.isDefaultSelected)
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 16,
                  child: Icon(Icons.check, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(IconData icon, String label, TextEditingController controller, [TextInputType keyboardType = TextInputType.text]) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            icon: Icon(icon, color: ConstantColors.getColor(ColorOptions.mainColor)),
            labelText: label,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            if (label == 'Age' && int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ),
    );
  }

  Future<void> addStudentData(StudentProvider provider, BuildContext context) async {
    final image = provider.image?.path;
    final student = StudentModel(
      name: provider.nameController.text,
      age: provider.ageController.text,
      phone: provider.phoneController.text,
      place: provider.placeController.text,
      photo: image,
    );

  
    await provider.addStudent(student);
    
  
    provider.clearFields();
    
    Navigator.pop(context);
  }
}
