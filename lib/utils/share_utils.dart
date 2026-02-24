import '../models/movie.dart';

String buildMovieShareContent(Movie movie) {
  return '${movie.title} (${movie.year})\n\nSinopse:\n${movie.plot}';
}
