import 'package:share_plus/share_plus.dart';

import '../models/movie.dart';

String buildMovieShareMessage(Movie movie) {
  final title = movie.title.trim();
  final year = movie.year.trim();
  final plot = movie.plot.trim();

  return 'Título: $title\nAno: $year\nSinopse: $plot';
}

class ShareService {
  const ShareService();

  Future<void> shareMovie(Movie movie) {
    return Share.share(buildMovieShareMessage(movie));
  }
}
