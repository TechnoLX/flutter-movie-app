import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constant/style.dart';
import 'package:flutter_movie_app/http/http_request.dart';
import 'package:flutter_movie_app/model/movie/movie_model.dart';
import 'package:page_indicator/page_indicator.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieModel>(
      future: HttpRequest.getMovies("now_playing"),
      builder: (context, AsyncSnapshot<MovieModel> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildNowPlayingWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Something is wrong : $error',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNowPlayingWidget(MovieModel data) {
    List<Movie>? movies = data.movies;
    if (movies!.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: const Center(
          child: Text(
            'No Movies found',
            style: TextStyle(
              fontSize: 20,
              color: Style.textColor,
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 220,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          indicatorSpace: 8,
          padding: const EdgeInsets.all(5),
          indicatorColor: Style.textColor,
          indicatorSelectorColor: Style.secondColor,
          length: movies.take(5).length,
          shape: IndicatorShape.circle(size: 10),
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index) {
              return Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/original" +
                                movies[index].backDrop!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Style.primaryColor.withOpacity(1),
                        Style.primaryColor.withOpacity(0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 0.9],
                    )),
                  ),
                  Positioned(
                    bottom: 30.0,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            movies[index].title!,
                            style: const TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }
  }
}
