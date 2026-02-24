import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sinopse_filmes_flutter/models/movie.dart';
import 'package:sinopse_filmes_flutter/screens/home_screen.dart';
import 'package:sinopse_filmes_flutter/services/movie_service.dart';
import 'package:sinopse_filmes_flutter/services/settings_service.dart';
import 'package:sinopse_filmes_flutter/services/share_service.dart';

class FakeMovieService extends MovieService {
  @override
  Future<Movie> searchMovie({required String title, required String apiKey}) {
    return Future.value(
      const Movie(
        title: 'Interestelar',
        year: '2014',
        plot: 'Exploradores viajam por um buraco de minhoca.',
      ),
    );
  }
}

class FakeSettingsService extends SettingsService {
  @override
  Future<String> getApiKey() => Future.value('fake-api-key');
}

class FakeShareService implements ShareService {
  String? sharedText;

  @override
  Future<void> shareText(String text) async {
    sharedText = text;
  }
}

void main() {
  testWidgets('renderiza tela inicial com ações principais', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    expect(find.text('Sinopse de Filmes'), findsOneWidget);
    expect(find.text('Buscar sinopse'), findsOneWidget);
    expect(find.text('Nome do filme'), findsOneWidget);
    expect(find.byTooltip('Compartilhar sinopse'), findsOneWidget);
  });

  testWidgets('informa quando tenta compartilhar sem resultado carregado', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    await tester.tap(find.byTooltip('Compartilhar sinopse'));
    await tester.pump();

    expect(
      find.text('Busque um filme antes de compartilhar a sinopse.'),
      findsOneWidget,
    );
  });

  testWidgets('compartilha título, ano e sinopse após busca', (tester) async {
    final fakeShareService = FakeShareService();

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          movieService: FakeMovieService(),
          settingsService: FakeSettingsService(),
          shareService: fakeShareService,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Interestelar');
    await tester.tap(find.text('Buscar sinopse'));
    await tester.pumpAndSettle();

    expect(find.text('Compartilhar sinopse'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Compartilhar sinopse'));
    await tester.pump();

    expect(
      fakeShareService.sharedText,
      'Interestelar (2014)\n\nSinopse:\nExploradores viajam por um buraco de minhoca.',
    );
  });
}
