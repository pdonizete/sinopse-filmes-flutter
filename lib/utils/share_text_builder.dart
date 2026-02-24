import '../models/movie.dart';

String buildMovieShareText(Movie movie) {
  return '🎬 ${movie.title} (${movie.year})\n\n📝 Sinopse:\n${movie.plot}';
}
