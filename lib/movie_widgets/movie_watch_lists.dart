import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constant/style.dart';
import 'package:flutter_movie_app/model/hive_movie_model.dart';
import 'package:flutter_movie_app/model/movie/movie_model.dart';
import 'package:flutter_movie_app/screens/movie_details_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MovieWatchLists extends StatefulWidget {
  const MovieWatchLists({Key? key}) : super(key: key);

  @override
  State<MovieWatchLists> createState() => _MovieWatchListsState();
}

class _MovieWatchListsState extends State<MovieWatchLists> {
  late Box<HiveMovieModel> _movieWatchLists;

  @override
  void initState() {
    _movieWatchLists = Hive.box<HiveMovieModel>('movie_lists');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: _movieWatchLists.isEmpty
          ? const Center(
              child: Text(
                "No Movies added to list yet!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Style.textColor,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ValueListenableBuilder(
                    valueListenable: _movieWatchLists.listenable(),
                    builder: (context, Box<HiveMovieModel> item, _) {
                      List<int> keys = item.keys.cast<int>().toList();
                      return ListView.builder(
                        itemCount: keys.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final key = keys[index];
                          final HiveMovieModel? _item = item.get(key);
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              onTap: () async {
                                Movie _movie = Movie();
                                _movie.id = _item!.id;
                                _movie.title = _item.title;
                                _movie.overview = _item.overview;
                                _movie.backDrop = _item.backDrop;
                                _movie.poster = _item.poster;
                                _movie.rating = _item.rating;

                                final refresh = await Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return MoviesDetailsScreen(
                                    movie: _movie,
                                    hiveId: index,
                                  );
                                }));

                                if (refresh) {
                                  setState(() {});
                                }
                              },
                              title: Text(_item!.title),
                              subtitle: Text(
                                _item.overview,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Image.network(
                                "https://image.tmdb.org/t/p/w200/" +
                                    _item.poster,
                                fit: BoxFit.cover,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _movieWatchLists.deleteAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
