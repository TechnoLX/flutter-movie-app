import 'package:flutter/material.dart';
import 'package:flutter_movie_app/movie_widgets/get_genres.dart';
import 'package:flutter_movie_app/movie_widgets/now_playing_widget.dart';
import 'package:flutter_movie_app/movie_widgets/movies_widget.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        NowPlaying(),
        GetGenres(),
        MoviesWidget(text: 'UPCOMING', request: 'upcoming'),
        MoviesWidget(text: 'POPULAR', request: 'popular'),
        MoviesWidget(text: 'TOP RATED', request: 'top_rated'),
      ],
    );
  }
}
