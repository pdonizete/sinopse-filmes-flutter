# QA Evidence - Compartilhamento de sinopse

## Escopo
Feature: botão de compartilhamento da sinopse com payload de título, ano e sinopse.

## Evidências automatizadas
- `/opt/flutter/bin/flutter analyze` ✅
- `/opt/flutter/bin/dart analyze` ✅
- `/opt/flutter/bin/flutter test` ✅
- `/opt/flutter/bin/flutter build apk --debug` ✅ (`build/app/outputs/flutter-apk/app-debug.apk`)
- `/opt/flutter/bin/flutter build apk --release` ✅ (`build/app/outputs/flutter-apk/app-release.apk`)

## Checklist manual Android (pré-PR)
- [ ] Instalar APK debug em dispositivo Android
- [ ] Buscar filme válido e validar presença do botão **Compartilhar sinopse**
- [ ] Acionar compartilhamento e validar abertura do share sheet nativo
- [ ] Confirmar opções como WhatsApp/Telegram (quando instalados)
- [ ] Validar payload contendo apenas Título, Ano e Sinopse
- [ ] Validar estado sem resultado: botão desabilitado, sem crash
- [ ] Validar TalkBack/foco/tooltip/semântica do botão

## Resultado
Na rodada de QA crítico desta branch, a implementação foi revisada contra `main`, porém ainda há bloqueios de compilação e cobertura parcial dos critérios de aceite. O merge deve ficar bloqueado até saneamento e nova rodada completa de validação.
