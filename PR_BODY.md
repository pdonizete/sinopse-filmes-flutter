## Resumo
- adiciona ação **Compartilhar sinopse** na tela de resultado
- usa share sheet nativo via `share_plus` (WhatsApp/Telegram/apps compatíveis)
- payload de compartilhamento com **Título, Ano e Sinopse**
- estado sem resultado com botão desabilitado (sem crash)
- cobertura de testes para payload, estado sem resultado e semântica/presença do botão
- documentação e notas de QA atualizadas

## Checklist Dev
- [x] Branch criada a partir da `main` atualizada (`feature/compartilhar-sinopse-ea2de0ef`)
- [x] Diff real vs `main`
- [x] Testes atualizados
- [x] Sem auto-merge
- [x] Sem publicação de release real

## Checklist QA
- [x] Testes automatizados verdes
- [x] Build Android debug/release gerado
- [x] Evidências registradas em `QA_EVIDENCE.md`
- [ ] Validação manual Android em dispositivo (pendente no PR)

## Checklist Docs
- [x] README atualizado com uso, limitações e cenário sem resultado
- [x] `RELEASE_DRAFT.md` atualizado

## Checklist DevOps
- [x] CI de PR para `main` executa analyze e test (`.github/workflows/ci.yml`)
- [x] Comandos locais executados com sucesso:
  - `/opt/flutter/bin/dart analyze`
  - `/opt/flutter/bin/flutter analyze`
  - `/opt/flutter/bin/flutter test`
