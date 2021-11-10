import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextPage extends StatefulWidget {
  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference profiles = FirebaseFirestore.instance.collection('Profile');
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: textController,
        ),
      ),
      body: Center(
          child: StreamBuilder(
              stream: profiles.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.data == null) return CircularProgressIndicator();
                return ListView(
                  children: snapshot.data.docs.map((profiles) {
                    return Center(
                        child: ListTile(
                      title: Text(
                        profiles['description']),
                    ));
                  }).toList(),
                );
              })),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.save),
                onPressed: (){
                  profiles.add({
                    'description' : textController.text,
                  });
                  textController.clear();
                },
              ),
    );
  }
}
