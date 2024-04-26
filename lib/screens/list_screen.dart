import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to show dialog for adding new items
  void addItemToList() async {
    TextEditingController itemController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add New Item"),
            content: TextField(
              controller: itemController,
              decoration: InputDecoration(hintText: "Enter item name"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (itemController.text.isNotEmpty) {
                    _firestore.collection('lists').add({
                      'name': itemController.text,
                      'items': [] // Assuming structure, update accordingly
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Add'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Lists'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('lists').snapshots(),
        builder: (BuildContext context, AsyncSnapshot) {
          var snapshot;
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Items: ${item['items'].join(', ')}'),
                    onTap: () {
                      // Implement onTap logic to navigate to a detailed view or editing interface
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(item: item)));
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _firestore.collection('lists').doc(item.id).delete();
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("No lists found."));
            }
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading lists: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItemToList,
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final DocumentSnapshot item;

  DetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']),
      ),
      body: ListView.builder(
        itemCount: item['items'].length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(item['items'][index]),
          );
        },
      ),
    );
  }
}
