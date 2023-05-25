import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {

  static Actor castToEntity( Cast cast ) => Actor(
      id        : cast.id,
      name      : cast.name,
      profilePath: getImagePath(cast.profilePath),
      character : cast.character
  );

  static String getImagePath( String? imagePath ) {
    return (imagePath != null)
      ? 'https://image.tmdb.org/t/p/w500$imagePath'
      : 'https://static.displate.com/857x1200/displate/2022-04-15/7422bfe15b3ea7b5933dffd896e9c7f9_46003a1b7353dc7b5a02949bd074432a.jpg';
  }
  
}