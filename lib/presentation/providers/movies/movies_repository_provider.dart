import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';

// repostorio inmutable

/// This code is creating a provider named `movieRepositoryProvider` using the `Provider` class from the
/// Flutter Riverpod package. The provider is created with a function that takes a `ref` parameter and
/// returns an instance of `MovieRepositoryImpl` initialized with an instance of `MoviedbDataSource`.
/// This provider can be used to obtain an instance of `MovieRepositoryImpl` throughout the app by
/// calling `context.read(movieRepositoryProvider)` or `context.watch(movieRepositoryProvider)`.
final movieRepositoryProvider = Provider( (ref) => MovieRepositoryImpl( MoviedbDataSource() ) );
