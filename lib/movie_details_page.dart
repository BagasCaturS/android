import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projecthttp/homepage.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late Future<MovieDetails> futureMovieDetails;

  @override
  void initState() {
    super.initState();
    futureMovieDetails = fetchMovieDetails();
  }

  Future<MovieDetails> fetchMovieDetails() async {
    final response = await http.get(Uri.parse('https://s3-id-jkt-1.kilatstorage.id/api/movies1.json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonBody = jsonDecode(response.body) as List<dynamic>;
      final movieJson = jsonBody.firstWhere((movie) => movie['id'] == widget.movie.id);
      return MovieDetails.fromJson(movieJson);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  void addToWatchlist() {
    // Add your implementation here to add the movie to the watchlist
    // You can use a state management solution like Provider or Riverpod to manage the watchlist

    // Show a snackbar when the movie is added to the watchlist
    final snackBar = SnackBar(
      content: Text('Added to Watchlist'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: FutureBuilder<MovieDetails>(
        future: futureMovieDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final movieDetails = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(widget.movie.image),
                  const SizedBox(height: 16.0),
                  Text('Title: ${widget.movie.title}', style: Theme.of(context).textTheme.titleLarge),
                  Text('Genre: ${widget.movie.genre}'),
                  Text('Director: ${movieDetails.director}'),
                  Text('Producer: ${movieDetails.producer}'),
                  Text('Plot: ${movieDetails.plot}'),
                  Text('Release Date: ${movieDetails.releaseDate}'),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: addToWatchlist,
                    child: const Text('Add to Watchlist'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class MovieDetails {
  final String director;
  final String producer;
  final String plot;
  final String releaseDate;

  MovieDetails({
    required this.director,
    required this.producer,
    required this.plot,
    required this.releaseDate,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      director: json['director'] as String,
      producer: json['producer'] as String,
      plot: json['plot'] as String,
      releaseDate: json['release_date'] as String,
    );
  }
}
