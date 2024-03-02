import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/constants/constantss.dart';
import 'package:student/models/studentmodel.dart';
import 'package:student/provider/studentprovider.dart';
import 'package:student/screens/student_list.dart';

class EditScreen extends StatelessWidget {
  final StudentModel student;
  final String id;

  EditScreen({
    super.key,
    required this.student,
    required this.id,
  });
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollNumberController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final StudentProvider _databaseService = StudentProvider();
  @override
  Widget build(BuildContext context) {
    nameController.text = student.name;
    rollNumberController.text = student.rollno;
    departmentController.text = student.department;
    phoneNumberController.text = student.phoneno;
    genderController.text = student.gender;
    Provider.of<StudentProvider>(context, listen: false)
        .setImageFileAsync(File(student.imageUrl));

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text('Edit Screen'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return StudentList();
                }));
              },
              icon: const Icon(
                Icons.person,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<StudentProvider>(
                    builder: (context, StudentProvider, child) {
                  return GestureDetector(
                    onTap: () {
                      StudentProvider.selectImageFromGallery();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      radius: 70,
                      backgroundImage: StudentProvider.imageFile.path.isNotEmpty
                          ? FileImage(StudentProvider.imageFile)
                          : null,
                      child: StudentProvider.imageFile.path.isEmpty
                          ? const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: kWhite,
                            )
                          : null,
                    ),
                  );
                }),
                kHeight,
                textformfield('Name', nameController),
                kHeight,
                textformfield('Roll Number', rollNumberController),
                kHeight,
                textformfield('Department', departmentController),
                kHeight,
                textformfield('PhoneNumber', phoneNumberController),
                kHeight,
                textformfield('Gender', genderController),
                kHeight,
                SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kDeepOrange),
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              Provider.of<StudentProvider>(context,
                                      listen: false)
                                  .imageFile
                                  .path
                                  .isNotEmpty) {
                            StudentModel updatedStudent = student.copyWith(
                              name: nameController.text,
                              rollno: rollNumberController.text,
                              department: departmentController.text,
                              phoneno: phoneNumberController.text,
                              gender: genderController.text,
                              imageUrl: Provider.of<StudentProvider>(context,
                                      listen: false)
                                  .imageFile
                                  .path,
                            );

                            _databaseService.updateStudent(id, updatedStudent);
                            nameController.clear();
                            rollNumberController.clear();
                            departmentController.clear();
                            phoneNumberController.clear();
                            genderController.clear();
                            Provider.of<StudentProvider>(context, listen: false)
                                .clearImage();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('changes saved successfully'),backgroundColor: kDeepOrange,
                              duration: Duration(seconds: 2),))  ;
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Save Changes',
                          style: kStyle,
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField textformfield(String label, TextEditingController controller) =>
      TextFormField(
        controller: controller,
        style: const TextStyle(color: kBlack, fontSize: 20),
        decoration: InputDecoration(
            label: Text(
              label,
              style: const TextStyle(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:
                    const BorderSide(color: Colors.deepOrange, width: 2.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:
                    const BorderSide(color: Colors.deepOrange, width: 2.5)),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  const BorderSide(color: Colors.deepOrange, width: 2.5),
            ),
            errorStyle: const TextStyle(color: kDeepOrange, fontSize: 15)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a $label';
          }
          return null;
        },
      );
}
