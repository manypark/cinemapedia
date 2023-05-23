import 'package:dio/dio.dart';

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/config/constans/enviroment.dart';
import 'package:cinemapedia/domain/datasources/actor_datasource.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorDbDataSource extends ActorsDataSource {

  final dio = Dio( BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key' : Environment.movieDBKey,
      'language': 'es-MX'
    }
  ));
  

  List<Actor> _jsonToActors( Map<String, dynamic> json) {

    final movieDBResponse = CreditsResponse.fromJson(json);

    final List<Actor> actors = movieDBResponse.cast.map((castDb) => ActorMapper.castToEntity(castDb) ).toList();
    
    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {

    final response = await dio.get('/movie/$movieId/credits');

    return _jsonToActors(response.data);
  }
  
}