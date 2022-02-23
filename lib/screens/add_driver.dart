import 'package:flutter/material.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({Key? key}) : super(key: key);

  @override
  _AddDriverScreenState createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Driver'),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircleAvatar(
                radius: 40,
                child: IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    size: 40,
                  ),
                  onPressed: () {
                    print('hello');
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
