import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  //textediting controllers
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Daily Notes"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    "My Notes",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      hintText: 'Enter Content',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('notes').add({
                        'title': titleController.text.trim(),
                        'content': contentController.text.trim(),
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      titleController.clear();
                      contentController.clear();
                    },
                    child: Text('Save Notes'),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('notes')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Text("No notes added");
                  } else {
                    return ListView.builder(
                      itemCount: docs.length,
                      shrinkWrap: true, // Added shrinkWrap to prevent unbounded height in Column
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final title = doc['title'];
                        final content = doc['content'];
                        return ListTile( 
                          title: Text(title),
                          subtitle: Text(content),
                          trailing: IconButton(
                            onPressed: (){
                                FirebaseFirestore.instance.
                                collection('notes').doc(doc.id).
                                delete();
                            },
                            icon: Icon(Icons.delete_forever,
                            color: Colors.red,)),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}