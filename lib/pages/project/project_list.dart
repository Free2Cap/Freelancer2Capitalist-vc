import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:freelancer2capitalist/models/UIHelper.dart';
import 'package:freelancer2capitalist/pages/project/project_form.dart';

import '../../models/user_model.dart';

class ProjectList extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const ProjectList(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  Future<void> deleteData(String documentId) async {
    // Delete data from Firestore
    await deleteImages(documentId);
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(documentId)
        .delete();
    Navigator.pop(context);
    // Delete images from Cloud Storage
  }

  Future<List<String>> getImageUrls(String documentId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('projects')
        .doc(documentId)
        .get();
    if (!snapshot.exists) {
      return []; // or throw an error
    }
    final data = snapshot.data()!;
    final imageUrls = List<String>.from(data['projectImages'] ?? []);
    return imageUrls;
  }

  Future<void> deleteImages(String documentId) async {
    final imageUrls = await getImageUrls(documentId);
    for (final url in imageUrls) {
      try {
        final reference = FirebaseStorage.instance.refFromURL(url);
        await reference.delete();
      } catch (e) {
        log('Error deleting image $url: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  centerTitle: true,
  title: Text(
    "Project List",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  backgroundColor: Colors.purple,
  iconTheme: IconThemeData(color: Colors.white),
  actions: [
    InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectForm(
            userModel: widget.userModel,
            firebaseUser: widget.firebaseUser,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purple,
        ),
        child: Icon(
          Icons.add_task_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
    ),
  ],
),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('projects')
                    .where('creator', isEqualTo: widget.userModel.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      return ListView.builder(
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            // Get the project data from the snapshot
                            final project = dataSnapshot.docs[index].data()
                                as Map<String, dynamic>;
                            // Build a ListTile for the project
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.purple,
                                      width: 2,
                                    ),
                                  ),
                                  child: Image.network(
                                    project["projectImages"][0],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                project["aim"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.purple,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProjectForm(
                                            firebaseUser: widget.firebaseUser,
                                            userModel: widget.userModel,
                                            projectId: project["uid"],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_red_eye),
                                    color: Colors.purple,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => ProjectDetailsDialog(
                                            project: project),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.purple,
                                    onPressed: () {
                                      UIHelper.showConfirmationAlertDialog(
                                        context,
                                        "Are you sure?",
                                        "Do you want to delete ${project['aim']}",
                                        (p0) {
                                          UIHelper.showLoadingDialog(
                                              context, 'Deleting');
                                          deleteData(project["uid"]);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text("An error occured ${snapshot.error}");
                    } else {
                      return const Center(
                        child: Text("No projects available"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
