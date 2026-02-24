# Draft de Release (manual)

> Este arquivo é um rascunho textual para apoiar a publicação manual de release. Não publica release automaticamente.

## Título sugerido

`vX.Y.Z - Secure API Key Storage + CI/CD`

## Resumo

- Migração de armazenamento da API key para `flutter_secure_storage`
- Migração automática de valor legado salvo em `shared_preferences`
- Ajustes na tela de Configurações para não exibir a chave já salva
- Novos testes de serviço para persistência e migração
- Pipelines GitHub Actions para CI, build de APK e release por tag

## Checklist antes de publicar

- [ ] Tag `vX.Y.Z` criada no commit correto
- [ ] CI verde (`flutter analyze` + `flutter test`)
- [ ] APK gerado e anexado (`app-release.apk`)
- [ ] Notas de release revisadas

## Artefato

- `app-release.apk`
