import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditNotesPage extends StatefulWidget {
  final String title;
  final String description;
  final String date;
  final List<String> images;

  const EditNotesPage({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.images,
  });

  @override
  EditNotesPageState createState() => EditNotesPageState();
}

class EditNotesPageState extends State<EditNotesPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _images = List<String>.from(widget.images);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width / (_images.isEmpty ? 1 : _images.length);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit Note'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              String updatedTitle = _titleController.text;
              String updatedDescription = _descriptionController.text;

              Navigator.pop(context, {
                'title': updatedTitle,
                'description': updatedDescription,
                'date': widget.date,
                'images': _images,
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
                hintText: 'Add Your Notes Here',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description Here',
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
                        Stack(
                          children: [
                            if (image.startsWith('assets/'))
                              Image.asset(image, width: imageWidth - 8, height: imageWidth - 8, fit: BoxFit.cover)
                            else
                              Image.file(File(image), width: imageWidth - 8, height: imageWidth - 8, fit: BoxFit.cover),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _images.remove(image);
                                  });
                                },
                                child: const Icon(Icons.remove_circle, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          width: imageWidth - 8,
                          height: imageWidth - 8,
                          color: Colors.grey,
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Date: ${widget.date}',
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}