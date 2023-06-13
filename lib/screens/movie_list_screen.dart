import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:kleiba_flutter_challenge/models/movie.dart';
import 'package:kleiba_flutter_challenge/screens/add_movie_screen.dart';

class MovieListScreen extends StatelessWidget {
  final Box<Movie> movieBox = Hive.box<Movie>('movies');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: const Text('Movie List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: movieBox.listenable(),
        builder: (context, Box<Movie> box, _) {
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final movie = box.getAt(index)!;
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: ListTile(
                        leading: Image.file(File(movie.posterUrl)),
                        //  CachedNetworkImage(
                        //   imageUrl: movie.posterUrl,
                        //   placeholder: (context, url) =>
                        //       CircularProgressIndicator(),
                        //   errorWidget: (context, url, error) =>
                        //       Icon(Icons.error),
                        // ),
                        title: Text(movie.name),
                        subtitle: Text(movie.director),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            box.deleteAt(index);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddMovieScreen()));
          // Navigate to the add movie screen
        },
      ),
    );
  }
}
