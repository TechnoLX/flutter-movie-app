import 'package:flutter/material.dart';
import 'package:flutter_movie_app/constant/style.dart';
import 'package:flutter_movie_app/http/http_request.dart';
import 'package:flutter_movie_app/model/reviews_model.dart';

class Reviews extends StatefulWidget {
  const Reviews({Key? key, required this.id, required this.request})
      : super(key: key);
  final int id;
  final String request;

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 20),
            child: Text(
              "REVIEWS",
              style: TextStyle(
                color: Style.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          FutureBuilder<ReviewsModel>(
            future: HttpRequest.getReviews(widget.request, widget.id),
            builder: (context, AsyncSnapshot<ReviewsModel> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.error != null &&
                    snapshot.data!.error!.isNotEmpty) {
                  return _buildErrorWidget(snapshot.data!.error);
                }
                return _buildReviewsWidget(snapshot.data!);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            },
          ),
        ],
      ),
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

  Widget _buildReviewsWidget(ReviewsModel data) {
    List<Review>? reviews = data.reviews;
    if (reviews!.isEmpty) {
      return const SizedBox(
        child: Center(
          child: Text(
            "There is no reviews shown",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
    } else {
      return Column(
        children: List.generate(reviews.length, (index) {
          return Card(
            color: Style.textColor,
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 5,
            child: ListTile(
              title: Text(
                reviews[index].content!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }),
      );
    }
  }
}
