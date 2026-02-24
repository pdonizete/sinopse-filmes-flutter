import 'package:flutter_test/flutter_test.dart';
import 'package:sinopse_filmes_flutter/models/movie.dart';
import 'package:sinopse_filmes_flutter/utils/share_utils.dart';

void main() {
  test('monta conteúdo de compartilhamento com título, ano e sinopse', () {
    const movie = Movie(
      title: 'Interestelar',
      year: '2014',
      plot: 'Um grupo parte em missão para encontrar um novo lar.',
    );

    final content = buildMovieShareContent(movie);

    expect(content, contains('Interestelar (2014)'));
    expect(content, contains('Sinopse:'));
    expect(
      content,
      contains('Um grupo parte em missão para encontrar um novo lar.'),
    );
  });
}
