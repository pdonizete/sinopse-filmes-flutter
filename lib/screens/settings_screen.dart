import 'package:flutter/material.dart';

import '../services/movie_service.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _settingsService = SettingsService();
  final _movieService = MovieService();

  bool _isSaving = false;
  bool _isTesting = false;
  bool _hasSavedKey = false;

  @override
  void initState() {
    super.initState();
    _loadApiKeyStatus();
  }

  Future<void> _loadApiKeyStatus() async {
    final key = await _settingsService.getApiKey();
    if (!mounted) return;
    setState(() {
      _hasSavedKey = key.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveKey() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await _settingsService.saveApiKey(_apiKeyController.text);
    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _hasSavedKey = true;
      _apiKeyController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chave de API salva com sucesso.')),
    );
  }

  Future<void> _testConnection() async {
    final typedApiKey = _apiKeyController.text.trim();
    final apiKeyToTest = typedApiKey.isNotEmpty
        ? typedApiKey
        : await _settingsService.getApiKey();

    if (apiKeyToTest.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe uma API key para testar a conexão.'),
        ),
      );
      return;
    }

    setState(() => _isTesting = true);

    try {
      await _movieService.searchMovie(title: 'Inception', apiKey: apiKeyToTest);

      if (typedApiKey.isNotEmpty) {
        await _settingsService.saveApiKey(typedApiKey);
      }

      if (!mounted) return;
      setState(() {
        _hasSavedKey = true;
        _apiKeyController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conexão com API validada com sucesso.')),
      );
    } on MovieServiceException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha no teste: ${e.message}')));
    } finally {
      if (mounted) {
        setState(() => _isTesting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: FocusTraversalGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_hasSavedKey)
                    Semantics(
                      liveRegion: true,
                      child: const Text(
                        'API key já configurada neste dispositivo. Informe uma nova chave para substituir a atual.',
                      ),
                    ),
                  if (_hasSavedKey) const SizedBox(height: 12),
                  Semantics(
                    textField: true,
                    label: 'Nova chave da API OMDb',
                    hint:
                        'Digite a sua nova chave de API e salve para atualizar',
                    child: TextFormField(
                      controller: _apiKeyController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nova API key (OMDb)',
                        hintText: 'Exemplo: abcd1234',
                        helperText:
                            'A chave é salva com armazenamento seguro local.',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe uma API key válida.';
                        }
                        if (value.trim().length < 6) {
                          return 'A API key parece curta demais.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Semantics(
                    button: true,
                    label: 'Salvar chave de API',
                    hint: 'Salva localmente a chave de API no aparelho',
                    child: FilledButton.icon(
                      onPressed: _isSaving ? null : _saveKey,
                      icon: const Icon(Icons.save),
                      label: Text(_isSaving ? 'Salvando...' : 'Salvar'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    button: true,
                    label: 'Testar conexão da API',
                    hint:
                        'Testa se a API key consegue consultar a API de filmes',
                    child: OutlinedButton.icon(
                      onPressed: _isTesting ? null : _testConnection,
                      icon: const Icon(Icons.wifi_tethering),
                      label: Text(
                        _isTesting ? 'Testando...' : 'Testar conexão',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
