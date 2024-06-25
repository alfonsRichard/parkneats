import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';  // tambahkan import ini

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
                        Image.file(image, width: 60, height: 60, fit: BoxFit.cover),
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          width: 60,
                          height: 60,
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

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  List<Map<String, dynamic>> notes = [
    {
      'images': ['assets/img/pinkbeach.jpg'],
      'title': 'Morning visit, Ocean Beach',
      'description': 'I dreamed about surfing last night. Whenever that happens, I know I\'m going to have a great day on the water. Sarah',
      'date': 'Tuesday, 12 Sep',
    },
    {
      'images': ['assets/img/mountdiablo.jpg'],
      'title': 'Afternoon hike, Mount Diablo',
      'description': 'What a day! Sheila and Marco are in town visiting from L.A. We went out to Mount Diablo to see the fields in bloom. The...',
      'date': 'Sunday, 20 Oct',
    },
  ];

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, dd MMM').format(date);
  }

  void _editNote(
      int index, String title, String description, String date, List<String> images) {
    setState(() {
      notes[index] = {
        'images': images,
        'title': title,
        'description': description,
        'date': date,
      };
    });
  }

  void _addNote(
      String title, String description, String? imageUrl) {
    setState(() {
      notes.add({
        'images': imageUrl != null ? [imageUrl] : ['assets/img/default.jpg'],  // Default image if no image is added
        'title': title,
        'description': description,
        'date': _formatDate(DateTime.now()),  // Formatted current date for the new note
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notes'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              NoteEntry(
                key: ValueKey(notes[index]['title']),
                images: List<String>.from(notes[index]['images']),
                title: notes[index]['title']!,
                description: notes[index]['description']!,
                date: notes[index]['date']!,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditNotesPage(
                        title: notes[index]['title']!,
                        description: notes[index]['description']!,
                        date: notes[index]['date']!,
                        images: List<String>.from(notes[index]['images']),
                      ),
                    ),
                  );

                  if (result != null) {
                    _editNote(
                      index,
                      result['title'],
                      result['description'],
                      result['date'],
                      List<String>.from(result['images']),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Mengarahkan pengguna ke halaman AddNotesPage
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotePage()),
          );

          if (result != null) {
            _addNote(
              result['title'],
              result['description'],
              result['images'],
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

  class NoteEntry extends StatelessWidget {
  final List<String> images;
  final String title;
  final String description;
  final String date;
  final VoidCallback? onTap;

  const NoteEntry({
    super.key, // Use super.key for the key parameter
    required this.images,
    required this.title,
    required this.description,
    required this.date,
    this.onTap,
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (images.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: images.map((imageUrl) {
                    if (imageUrl.startsWith('assets/')) {
                      return Image.asset(imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover);
                    } else {
                      return Image.file(File(imageUrl), width: double.infinity, height: 200, fit: BoxFit.cover);
                    }
                  }).toList(),
                ),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
              if (date.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black38,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


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
    return Scaffold(
      appBar: AppBar(
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
                              Image.asset(image, width: 100, height: 100, fit: BoxFit.cover)
                            else
                              Image.file(File(image), width: 100, height: 100, fit: BoxFit.cover),
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
                          width: 100,
                          height: 100,
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
