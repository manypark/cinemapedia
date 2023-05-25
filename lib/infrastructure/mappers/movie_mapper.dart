import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {

  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      id              : moviedb.id,
      adult           : moviedb.adult,
      backdropPath    : getImagePath(moviedb.backdropPath),
      genreIds        : moviedb.genreIds.map((e) => e.toString()).toList(),
      originalLanguage: moviedb.originalLanguage,
      originalTitle   : moviedb.originalTitle,
      overview        : moviedb.overview,
      popularity      : moviedb.popularity,
      posterPath      : getImagePath(moviedb.posterPath),
      releaseDate     : moviedb.releaseDate != null ? moviedb.releaseDate! :  DateTime.now(),
      title           : moviedb.title,
      video           : moviedb.video,
      voteAverage     : moviedb.voteAverage,
      voteCount       : moviedb.voteCount
  );

  static Movie movieDetailsToEntity( MovieDetails moviedb) => Movie(
    id              : moviedb.id,
    adult           : moviedb.adult,
    backdropPath    : getImagePath(moviedb.backdropPath),
    genreIds        : moviedb.genres.map((e) => e.name ).toList(),
    originalLanguage: moviedb.originalLanguage,
    originalTitle   : moviedb.originalTitle,
    overview        : moviedb.overview,
    popularity      : moviedb.popularity,
    posterPath      : getImagePath(moviedb.posterPath),
    releaseDate     : moviedb.releaseDate,
    title           : moviedb.title,
    video           : moviedb.video,
    voteAverage     : moviedb.voteAverage,
    voteCount       : moviedb.voteCount
  );

  static String getImagePath( String imagePath ) {
    return (imagePath != '')
      ? 'https://image.tmdb.org/t/p/w500$imagePath'
      : 'https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg';
  }

}
