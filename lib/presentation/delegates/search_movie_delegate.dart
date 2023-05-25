import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

typedef SearchMoviesCallBack = Future<List<Movie>> Function( String query );

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMoviesCallBack searchMovies;

  SearchMovieDelegate({
    required this.searchMovies,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [

        FadeInRight(
          animate : query.isNotEmpty,
          duration: const Duration( milliseconds: 500 ),
          child   : IconButton(
            onPressed: () => query = '',
            icon     : const Icon( Icons.clear ),
          ),
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon     : const Icon( Icons.arrow_back_sharp )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future  : searchMovies( query ),
      builder : (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount  : movies.length,
          itemBuilder: (context, index) => _MovieItem( movie: movies[index],),
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Buscar película';
  
}

class _MovieItem extends StatelessWidget {

  final Movie movie;

  const _MovieItem({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    final size       = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 10.0, vertical: 5.0 ),
      child: Row(
        children: [

          SizedBox(
            width: size.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child       : Image.network(
                movie.posterPath,
                loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
              ),
            ),
          ),

          const SizedBox( width: 10.0 ,),

          //description
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children          : [

                Text(movie.title, style: textStyles.titleMedium,),

                ( movie.overview.length > 100 ) ? Text('${movie.overview.substring(0, 100)}...') : Text(movie.overview,),

                Row(
                  children: [
                    Icon( Icons.star_half_rounded, color: Colors.yellow.shade800 ),
                    const SizedBox( width: 10.0 ,),
                    Text( HumanFormats.number(movie.voteAverage, 1), style: textStyles.bodyMedium!.copyWith( color: Colors.yellow.shade900 ) ),
                  ],
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}
