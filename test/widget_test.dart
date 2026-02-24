import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sinopse_filmes_flutter/models/movie.dart';
import 'package:sinopse_filmes_flutter/screens/home_screen.dart';
import 'package:sinopse_filmes_flutter/services/movie_service.dart';
import 'package:sinopse_filmes_flutter/services/settings_service.dart';
import 'package:sinopse_filmes_flutter/services/share_service.dart';

void main() {
  testWidgets('renderiza tela inicial com ação de compartilhar acessível', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    expect(find.text('Sinopse de Filmes'), findsOneWidget);
    expect(find.text('Buscar sinopse'), findsOneWidget);
    expect(find.text('Nome do filme'), findsOneWidget);
    expect(find.text('Compartilhar'), findsOneWidget);
    expect(find.bySemanticsLabel('Compartilhar sinopse'), findsOneWidget);
  });

  testWidgets('mostra aviso quando tenta compartilhar sem resultado carregado', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    await tester.tap(find.text('Compartilhar'));
    await tester.pumpAndSettle();

    expect(find.text('Busque um filme antes de compartilhar.'), findsOneWidget);
  });

  testWidgets('compartilha título, ano e sinopse após buscar filme', (tester) async {
    final shareService = _FakeShareService();

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          movieService: _FakeMovieService(),
          settingsService: _FakeSettingsService(),
          shareService: shareService,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Matrix');
    await tester.tap(find.text('Buscar sinopse'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Compartilhar'));
    await tester.pumpAndSettle();

    expect(shareService.sharedText, isNotNull);
    expect(shareService.sharedText, contains('Filme Teste'));
    expect(shareService.sharedText, contains('(1999)'));
    expect(shareService.sharedText, contains('Uma sinopse de teste.'));
  });
}

class _FakeMovieService extends MovieService {
  @override
  Future<Movie> searchMovie({required String title, required String apiKey}) {
    return Future.value(
      const Movie(
        title: 'Filme Teste',
        year: '1999',
        plot: 'Uma sinopse de teste.',
      ),
    );
  }
}

class _FakeSettingsService extends SettingsService {
  @override
  Future<String> getApiKey() => Future.value('api-key-valida');
}

class _FakeShareService extends ShareService {
  String? sharedText;

  @override
  Future<void> shareText(String content) async {
    sharedText = content;
  }
}
