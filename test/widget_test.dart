import 'package:flutter_test/flutter_test.dart';
import 'package:sinopse_filmes_flutter/main.dart';

void main() {
  testWidgets('renderiza tela inicial com campo de filme', (tester) async {
    await tester.pumpWidget(const SinopseFilmesApp());

    expect(find.text('Sinopse de Filmes'), findsOneWidget);
    expect(find.text('Buscar sinopse'), findsOneWidget);
    expect(find.text('Nome do filme'), findsOneWidget);
    expect(find.byTooltip('Compartilhar sinopse'), findsOneWidget);
  });

  testWidgets('exibe aviso ao compartilhar sem resultado carregado', (
    tester,
  ) async {
    await tester.pumpWidget(const SinopseFilmesApp());

    await tester.tap(find.byTooltip('Compartilhar sinopse'));
    await tester.pump();

    expect(
      find.text('Busque um filme antes de compartilhar a sinopse.'),
      findsOneWidget,
    );
  });
}
