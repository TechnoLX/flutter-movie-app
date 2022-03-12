class TVModel {
  final List<TVShows>? tvShows;
  final String? error;

  TVModel({this.tvShows, this.error});

  factory TVModel.fromJson(Map<String, dynamic> json) => TVModel(
        tvShows: (json["results"] as List)
            .map((data) => TVShows.fromJson(data))
            .toList(),
        error: "",
      );

  factory TVModel.withError(String error) => TVModel(
        tvShows: [],
        error: error,
      );
}

class TVShows {
  int? id;
  double? rating;
  String? name;
  String? backDrop;
  String? poster;
  String? overview;

  TVShows({
    this.id,
    this.rating,
    this.name,
    this.backDrop,
    this.poster,
    this.overview,
  });

  factory TVShows.fromJson(Map<String, dynamic> json) => TVShows(
        id: json['id'],
        rating: json['vote_average'].toDouble(),
        name: json['name'],
        backDrop: json['backdrop_path'],
        poster: json['poster_path'],
        overview: json['overview'],
      );
}
