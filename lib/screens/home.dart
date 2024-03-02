import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/constants/constantss.dart';
import 'package:student/models/studentmodel.dart';
import 'package:student/provider/studentprovider.dart';
import 'package:student/screens/student_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollNumberController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final StudentProvider _databaseService = StudentProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Add Student',
          //style: kStyle,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return StudentList();
                }));
              },
              icon: const Icon(
                Icons.person,
                //color: kWhite,
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
                    builder: (context, studentProvider, child) {
                  return GestureDetector(
                    onTap: () {
                      studentProvider.selectImageFromGallery();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      radius: 70,
                      backgroundImage: studentProvider.imageFile.path.isNotEmpty
                          ? FileImage(studentProvider.imageFile)
                          : null,
                      child: studentProvider.imageFile.path.isEmpty
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
                textformfield('Roll Number', rollNumberController,
                    keyBoardType: TextInputType.number),
                kHeight,
                textformfield('Department', departmentController),
                kHeight,
                textformfield('PhoneNumber', phoneNumberController,
                    keyBoardType: TextInputType.phone),
                kHeight,
                textformfield('Gender', genderController),
                kHeight,
                SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            Provider.of<StudentProvider>(context, listen: false)
                                .imageFile
                                .path
                                .isNotEmpty) {
                          final student = StudentModel(
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

                          _databaseService.addStudent(student);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Added successfully'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ));

                          nameController.clear();
                          rollNumberController.clear();
                          departmentController.clear();
                          phoneNumberController.clear();
                          genderController.clear();

                          Provider.of<StudentProvider>(context, listen: false)
                              .clearImage();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Please fill all fields',
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                      ),
                      child: const Text(
                        'Add Student',
                        style: kStyle,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField textformfield(String label, TextEditingController controller,
          {TextInputType? keyBoardType}) =>
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
        keyboardType: keyBoardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a $label';
          }
          return null;
        },
      );
}
