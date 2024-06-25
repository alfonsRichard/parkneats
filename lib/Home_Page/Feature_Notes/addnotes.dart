import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  AddNotePageState createState() => AddNotePageState();
}

class AddNotePageState extends State<AddNotePage> {
  final List<File> _images = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('EEEE, dd MMM');
    return formatter.format(date);
  }

 @override
Widget build(BuildContext context) {
  double imageWidth = (MediaQuery.of(context).size.width - (8 * (_images.length - 1))) / _images.length;

  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      title: const Text('Add Note'),
      backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      actions: [
        IconButton(
          icon: const Icon(Icons.done),
          onPressed: () {
            String title = _titleController.text;
            String description = _descriptionController.text;
            String date = _formatDate(DateTime.now());

            Navigator.pop(context, {
              'title': title,
              'description': description,
              'images': _images.isNotEmpty ? _images[0].path : null,
              'date': date,
            });
          },
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Add Your Notes Here',
              border: InputBorder.none,
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    for (var image in _images)
                      Image.file(image, width: imageWidth, height: imageWidth, fit: BoxFit.cover),
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        width: imageWidth,
                        height: imageWidth,
                        color: Colors.grey,
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}