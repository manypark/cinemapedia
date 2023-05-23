import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({
    super.key, 
    required this.movieId,
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();
    ref.read( movieInfoProvider.notifier ).loadMovie(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch( movieInfoProvider )[widget.movieId];

    if( movie == null ) {
      return const Scaffold( body: Center( child: CircularProgressIndicator() ) );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovideDetails( movie: movie ),
              childCount: 1,
            ))
        ],
      ),
    );
  }
}

class _MovideDetails extends StatelessWidget {

  final Movie movie;

  const _MovideDetails({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size        = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children          : [
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child       : Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox( width: 10.0 ,),

              // desc
              SizedBox(
                width: ( size.width - 40 ) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children          : [
                    Text( movie.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0 ) ,),
                    const SizedBox( height: 10.0 ,),
                    Text( movie.overview ,),
                  ],
                ),
              ),

            ],
          ),
        ),

        //generos de la pelicula
        Padding(
          padding: const EdgeInsets.all(8),
          child  : Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only( right: 10.0 ),
                child : Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular( 20.0 ) ),
                ),
              ))
            ],
          ),
        ),

        const SizedBox( height: 150.0 ),
      ],
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomSliverAppBar({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor : Colors.black,
      expandedHeight  : size.height * 0.7,
      foregroundColor : Colors.white,
      flexibleSpace    : FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric( horizontal: 10.0, vertical: 5.0 ),
        title       : Text( movie.title, style: const TextStyle( fontSize: 20.0 ),),
        background  : Stack(
          children: [

            SizedBox.expand(
              child: Image.network(movie.posterPath, fit: BoxFit.cover,),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin : Alignment.topCenter,
                    end   : Alignment.bottomCenter,
                    stops: [ 0.7, 1.0 ],
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                    ]
                  )
                )
              ),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin : Alignment.topLeft,
                    stops: [ 0.0, 0.2 ],
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                    ]
                  )
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}