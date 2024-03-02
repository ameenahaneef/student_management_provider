import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/constants/constantss.dart';
import 'package:student/models/studentmodel.dart';
import 'package:student/provider/studentprovider.dart';
import 'package:student/screens/home.dart';
import 'package:student/screens/student_details.dart';

class StudentList extends StatelessWidget {
  StudentList({super.key});
 // final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      final StudentProvider _databaseService = Provider.of<StudentProvider>(context);

   
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        automaticallyImplyLeading: false,
        title: const Text(
          'Student List',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return HomeScreen();
                }));
              },
              icon: const Icon(
                Icons.add,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
             TextFormField(
             // controller: searchController,
              onChanged: (value) {
             
              _databaseService.setSearchTxt(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: kDeepOrange),
                ),
                hintText: 'Search by Name',
              ),
            ),
kHeight,
            Expanded(
              child: StreamBuilder(
                  stream:_databaseService.searchTxt==null
      ? _databaseService.getStudents()
      : _databaseService.searchStudents(_databaseService.searchTxt!.toLowerCase()),
                  builder: (context, snapshot) {
                    List students = snapshot.data?.docs ?? [];
                    if (students.isEmpty) {
                      return const Center(
                        child: Text('No students',style: TextStyle(color: Colors.red,fontSize: 20),),
                      );
                    }
              
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 10),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          StudentModel studentModel = students[index].data();
                          String studentId = students[index].id;
                                  
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (ctx) {
                                return StudentDetails(
                                  student: studentModel,
                                  id: studentId,
                                );
                              }));
                            },
                            child: Card(
                              elevation: 3,
                              color: kDeepOrange,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: FileImage(
                                          File(studentModel.imageUrl)),
                                    ),
                                    Text(
                                      studentModel.name,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      studentModel.department,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
