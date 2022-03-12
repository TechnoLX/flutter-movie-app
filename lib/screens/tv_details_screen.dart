import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constant/style.dart';
import 'package:flutter_movie_app/model/hive_tv_model.dart';
import 'package:flutter_movie_app/model/tv/tv_model.dart';
import 'package:flutter_movie_app/screens/reviews.dart';
import 'package:flutter_movie_app/screens/trailers_screen.dart';
import 'package:flutter_movie_app/tv_widgets/similar_tv_widget.dart';
import 'package:flutter_movie_app/tv_widgets/tv_info.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TVsDetailsScreen extends StatefulWidget {
  const TVsDetailsScreen(
      {Key? key, required this.tvShows, this.request, this.hiveId})
      : super(key: key);
  final TVShows tvShows;
  final String? request;
  final int? hiveId;

  @override
  State<TVsDetailsScreen> createState() => _TVsDetailsScreenState();
}

class _TVsDetailsScreenState extends State<TVsDetailsScreen> {
  late Box<HiveTVModel> _tvWatchLists;

  @override
  void initState() {
    _tvWatchLists = Hive.box<HiveTVModel>('tv_lists');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(
          widget.tvShows.name!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: [
                _buildBackDrop(),
                Positioned(
                  top: 150,
                  left: 30,
                  child: Hero(
                    tag: widget.request == null
                        ? "${widget.tvShows.id}"
                        : "${widget.tvShows.id}" + widget.request!,
                    child: _buildPoster(),
                  ),
                ),
              ],
            ),
            TVsInfo(id: widget.tvShows.id!),
            SimilarTVs(id: widget.tvShows.id!),
            Reviews(
              id: widget.tvShows.id!,
              request: "tv",
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.redAccent,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          TrailersScreen(shows: "tv", id: widget.tvShows.id!),
                    ));
                  },
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Watch Trailers',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Style.secondColor,
                child: TextButton.icon(
                  onPressed: () {
                    if (widget.hiveId == null) {
                      HiveTVModel newValue = HiveTVModel(
                        id: widget.tvShows.id!,
                        rating: widget.tvShows.rating!,
                        name: widget.tvShows.name!,
                        backDrop: widget.tvShows.backDrop!,
                        poster: widget.tvShows.poster!,
                        overview: widget.tvShows.overview!,
                      );
                      _tvWatchLists.add(newValue);
                      _showAlertDialog();
                    }
                    if (widget.hiveId != null) {
                      _tvWatchLists.deleteAt(widget.hiveId!);
                      Navigator.of(context).pop(true);
                    }
                  },
                  icon: Icon(
                    widget.hiveId == null
                        ? Icons.list_alt_outlined
                        : Icons.delete,
                    size: 30,
                    color: Colors.white,
                  ),
                  label: Text(
                    widget.hiveId == null ? 'Add To Lists' : 'Delete This',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPoster() {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(
            "https://image.tmdb.org/t/p/w200/" + widget.tvShows.poster!,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBackDrop() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
            image: NetworkImage(
              "https://image.tmdb.org/t/p/original/" + widget.tvShows.backDrop!,
            ),
            fit: BoxFit.cover),
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Added to List"),
          content:
              Text("${widget.tvShows.name!} successfully added to watch list"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
