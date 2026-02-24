import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sinopse_filmes_flutter/screens/home_screen.dart';

void main() {
  testWidgets('renderiza tela inicial com ações principais', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    expect(find.text('Sinopse de Filmes'), findsOneWidget);
    expect(find.text('Buscar sinopse'), findsOneWidget);
    expect(find.text('Compartilhar sinopse'), findsOneWidget);
    expect(find.text('Nome do filme'), findsOneWidget);
  });

  testWidgets('botão de compartilhar inicia desabilitado sem resultado', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    final shareButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Compartilhar sinopse'),
    );

    expect(shareButton.onPressed, isNull);
    expect(find.bySemanticsLabel('Compartilhar sinopse'), findsWidgets);
    expect(find.byTooltip('Compartilhar sinopse'), findsOneWidget);
  });
}
