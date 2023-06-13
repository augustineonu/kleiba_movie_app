import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:kleiba_flutter_challenge/models/movie.dart';

import 'package:kleiba_flutter_challenge/models/movie.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  File? _posterImage;
  String downloadURL = '';

  // Future<String> uploadImage(File imageFile) async {
  //   try {
  //     final storageRef = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child('movie_posters');
  //     final uploadTask = storageRef.putFile(imageFile);
  //     final snapshot = await uploadTask.whenComplete(() {});
  //     downloadURL = await snapshot.ref.getDownloadURL();
  //     return downloadURL;
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return '';
  //   }
  // }

  Future<void> _selectPosterImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _posterImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveMovie() async {
    final movieBox = Hive.box<Movie>('movies');

    final newMovie = Movie()
      ..name = _nameController.text
      ..director = _directorController.text
      ..posterUrl = _posterImage!.path; // TODO: Upload the image and get the URL

    // if (_posterImage != null) {
    //   final imageUrl = await uploadImage(_posterImage!);
    //   newMovie.posterUrl = imageUrl;
    // }

    movieBox.add(newMovie);

    Navigator.pop(context); // Go back to the movie list screen
  }

  @override
  void dispose() {
    _nameController.dispose();
    _directorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.blueAccent,

      appBar: AppBar(
        title: const Text('Add Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _directorController,
              decoration: InputDecoration(
                labelText: 'Director',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _selectPosterImage,
              child: Text('Select Poster Image'),
            ),
            const SizedBox(height: 16.0),
            if (_posterImage != null)
              Image.file(
                _posterImage!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveMovie,
              child: Text('Save Movie'),
            ),
          ],
        ),
      ),
    );
  }
}
