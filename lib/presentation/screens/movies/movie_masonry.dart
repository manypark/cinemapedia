import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';

class MovieMasonry extends StatefulWidget {

  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MovieMasonry({
    super.key, 
    this.loadNextPage,
    required this.movies, 
  });

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {

  // TODO: initState

  //TODO dispose

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 10 ),
      child: MasonryGridView.count(
        crossAxisCount  : 3,
        itemCount       : widget.movies.length,
        crossAxisSpacing: 10,
        mainAxisSpacing : 10,
        itemBuilder     : (context, index) {

          if( index == 1 ) {
            return Column(
              children: [
                const SizedBox( height: 30,),
                MoviePosterLink( movie: widget.movies[index] )
              ],
            );
          }
          return MoviePosterLink( movie: widget.movies[index] );
        },
      ),
    );
  }
}
