import 'package:flutter/material.dart';
import 'package:projecthttp/movie_details_page.dart';
import 'package:projecthttp/homepage.dart';

class WatchlistPage extends StatefulWidget {
  final List<Movie> watchlistMovies;

  const WatchlistPage({Key? key, required this.watchlistMovies}) : super(key: key);

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
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
      body: widget.watchlistMovies.isEmpty
          ? Center(
        child: Text('No movies in the watchlist'),
      )
          : ListView.builder(
        itemCount: widget.watchlistMovies.length,
        itemBuilder: (context, index) {
          final movie = widget.watchlistMovies[index];
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
