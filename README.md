# sinopse-filmes-flutter

App Flutter para buscar sinopse de filmes usando a API pública [OMDb](https://www.omdbapi.com/).

## Funcionalidades

- Busca de filme por nome
- Exibição de título, ano e sinopse completa
- Compartilhamento da sinopse na tela principal com botão **Compartilhar** (share sheet nativo via `share_plus`)
  - conteúdo compartilhado: título, ano e sinopse do filme
  - funciona com WhatsApp, Telegram e outros apps compatíveis no dispositivo
- Tratamento de caso sem resultado ao compartilhar, exibindo `SnackBar` orientando a buscar um filme antes
- Tratamento de erro para:
  - chave de API ausente/inválida
  - filme não encontrado
  - falha de rede
- Tela de configurações para salvar API key com armazenamento seguro (`flutter_secure_storage`)
- Migração automática e transparente da chave legada salva em `shared_preferences`
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

## Armazenamento seguro e migração

- A API key agora é salva em armazenamento seguro local (`flutter_secure_storage`).
- Se existir um valor legado em `shared_preferences`, o app migra automaticamente na primeira leitura:
  1. lê o valor legado,
  2. grava no armazenamento seguro,
  3. remove o valor antigo.
- A tela de Configurações não pré-carrega o segredo salvo, evitando exposição visual da chave já persistida.

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
- botão **Compartilhar** com semântica dedicada para leitores de tela
- mensagens de erro e resultado com `liveRegion`
- contraste e estrutura visual simples para leitura
- campo de API key com entrada protegida (`obscureText`) e sem exibição da chave já salva

## Arquitetura e testabilidade

- Recurso de compartilhamento encapsulado em `ShareService`
- Injeção de dependência do serviço na `HomeScreen` para facilitar mocks em testes
- Testes de widget cobrindo:
  - renderização do botão de compartilhar
  - acessibilidade do botão
  - cenário sem resultado (SnackBar)
  - compartilhamento com conteúdo esperado

## Qualidade

Comandos utilizados para validação:

```bash
/opt/flutter/bin/flutter pub get
/opt/flutter/bin/flutter analyze
/opt/flutter/bin/flutter test
/opt/flutter/bin/flutter build apk --release
```

## CI/CD (GitHub Actions)

Workflows em `.github/workflows`:

- `ci.yml`: executa `flutter analyze` e `flutter test` em push/PR para `main`
- `build-apk.yml`: gera APK release e publica artefato de build
- `release.yml`: em tags `v*.*.*`, gera APK release e anexa `app-release.apk` na release do GitHub
