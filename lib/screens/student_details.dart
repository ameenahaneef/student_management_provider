import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student/constants/constantss.dart';
import 'package:student/models/studentmodel.dart';
import 'package:student/provider/studentprovider.dart';
import 'package:student/screens/editscreen.dart';

class StudentDetails extends StatelessWidget {
  final StudentModel student;
  final String id;
  StudentDetails({super.key, required this.student, required this.id});
  final StudentProvider _databaseService = StudentProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Details',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, top: 80),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: kDeepOrange),
            width: 300,
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 90,
                      backgroundImage: FileImage(File(student.imageUrl)),
                    ),
                  ),
                  Text(
                    'Name:${student.name}',
                    style: ksize,
                  ),
                  Text(
                    'Roll No:${student.rollno}',
                    style: ksize,
                  ),
                  Text(
                    'Department:${student.department}',
                    style: ksize,
                  ),
                  Text(
                    'Phone No:${student.phoneno}',
                    style: ksize,
                  ),
                  Text(
                    'Gender:${student.gender}',
                    style: ksize,
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (ctx) {
                                return EditScreen(
                                  student: student,
                                  id: id,
                                );
                              }));
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: kWhite,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('confirm delete'),
                                  content: Text('Are you sure you want to delete'),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: Text('cancel')),
                                    TextButton(onPressed: (){
                                      _databaseService.deleteStudent(id);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }, child: Text('Ok'))
                                  ],
                                );
                              });
                              
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: kBlack,
                              size: 25,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}
