import 'package:flutter/material.dart';
import 'package:myapp/notes.dart';
import 'package:firebase_core/firebase_core.dart';

void main(List<String> args)async{ 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDRottSON-Gt3n1niiRvAIg6bqP-Df5CFE",
       appId: "1:914762232730:android:a198401f9570918bff8023",
        messagingSenderId: "914762232730",
         projectId: "notesapp-a4da3")
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Note(),
    );
  }
}

