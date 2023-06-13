import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projecthttp/movie_details_page.dart';
import 'package:projecthttp/homepage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
//bagian watch list seharusnya bsia nampilin dari papa yang kita tambah ke watch list
//tapi for demonstration sake we're just gonna take 3 movies from the json file
//card bisa diambil dari homepage.dart
class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key, required List watchlistMovies}) : super(key: key);

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  List<Movie> watchlistMovies = []; // List to store the movies in the watchlist

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('https://s3-id-jkt-1.kilatstorage.id/api/movies1.json'));

    if (response.statusCode == 200) {
      final List<dynamic> moviesJson = jsonDecode(response.body) as List<dynamic>;
      final List<Movie> movies = moviesJson
          .map((json) => Movie.fromJson(json))
          .take(3) // Take only the first 3 movies for demonstration purposes
          .toList();

      setState(() {
        watchlistMovies = movies;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  void navigateToMovieDetailsPage(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailsPage(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: watchlistMovies.isEmpty
          ? Center(
        child: Text('No movies in the watchlist'),
      )
          : ListView.builder(
        itemCount: watchlistMovies.length,
        itemBuilder: (context, index) {
          final movie = watchlistMovies[index];
          return ListTile(
            leading: Image.network(movie.image),
            title: Text(movie.title),
            subtitle: Text(movie.genre),
            onTap: () {
              navigateToMovieDetailsPage(movie);
            },
          );
        },
      ),
    );
  }
}
