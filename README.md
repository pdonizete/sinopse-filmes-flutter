# sinopse-filmes-flutter

App Flutter para buscar sinopse de filmes usando a API pública [OMDb](https://www.omdbapi.com/).

## Funcionalidades

- Busca de filme por nome
- Exibição de título, ano e sinopse completa
- Tratamento de erro para:
  - chave de API ausente/inválida
  - filme não encontrado
  - falha de rede
- Tela de configurações para salvar API key localmente com `SharedPreferences`
- Botão para testar conexão com a API

## Como rodar

```bash
cd /home/ubuntu/projetos/sinopse-filmes-flutter
/opt/flutter/bin/flutter pub get
/opt/flutter/bin/flutter run
```

## Como configurar API key

1. Crie uma chave gratuita em: https://www.omdbapi.com/apikey.aspx
2. Abra o app e toque no ícone de **Configurações** (engrenagem)
3. Informe a API key e clique em **Salvar**
4. (Opcional) Clique em **Testar conexão** para validar a chave
5. Volte para a Home, digite o nome do filme e clique em **Buscar sinopse**

## Gerar APK release

```bash
cd /home/ubuntu/projetos/sinopse-filmes-flutter
/opt/flutter/bin/flutter build apk --release
```

APK gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Acessibilidade (TalkBack/VoiceOver)

As telas principais incluem:

- `Semantics` com labels/hints em campos e botões
- ordem lógica de foco com `FocusTraversalGroup` e `OrdinalSortKey`
- tooltips nos principais botões de ação
- mensagens de erro e resultado com `liveRegion`
- contraste e estrutura visual simples para leitura

## Qualidade

Comandos utilizados para validação:

```bash
/opt/flutter/bin/flutter pub get
/opt/flutter/bin/flutter analyze
/opt/flutter/bin/flutter test
/opt/flutter/bin/flutter build apk --release
```
