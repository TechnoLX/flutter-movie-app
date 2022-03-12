import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constant/style.dart';
import 'package:flutter_movie_app/http/http_request.dart';
import 'package:flutter_movie_app/model/genres_model.dart';
import 'package:flutter_movie_app/model/tv/tv_details_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TVsInfo extends StatefulWidget {
  const TVsInfo({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<TVsInfo> createState() => _TVsInfoState();
}

class _TVsInfoState extends State<TVsInfo> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TVDetailsModel>(
      future: HttpRequest.getTVShowsDetails(widget.id),
      builder: (context, AsyncSnapshot<TVDetailsModel> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildInfoWidget(snapshot.data!);
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

  Widget _buildInfoWidget(TVDetailsModel data) {
    TVDetails detail = data.details!;
    return Column(children: <Widget>[
      _buildRating(detail),
      const SizedBox(
        height: 10,
      ),
      _buildOverview(detail.overview),
      const SizedBox(
        height: 10,
      ),
      _buildGenreList(detail.genres),
    ]);
  }

  Widget _buildGenreList(List<Genre>? genres) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "GENRES",
            style: TextStyle(
              color: Style.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Container(
            height: 35,
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: Text(
                      genres[index].name!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 9,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(String? overview) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "OVERVIEW",
            style: TextStyle(
              color: Style.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            overview!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating(TVDetails details) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 120,
          ),
          Expanded(
            child: SizedBox(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          details.rating!.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        RatingBar.builder(
                          itemSize: 20,
                          initialRating: details.rating! / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 2),
                          itemBuilder: (context, _) {
                            return const Icon(
                              Icons.star,
                              color: Style.secondColor,
                            );
                          },
                          onRatingUpdate: (rating) {},
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "TOTAL EPISODES",
                              style: TextStyle(
                                color: Style.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${details.numberOfEpisodes!}',
                              style: const TextStyle(
                                color: Style.secondColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "FIRST AIRING DATE",
                              style: TextStyle(
                                color: Style.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${details.firstAirDate!}',
                              style: const TextStyle(
                                color: Style.secondColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
