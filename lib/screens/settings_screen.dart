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

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final key = await _settingsService.getApiKey();
    _apiKeyController.text = key;
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
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chave de API salva com sucesso.')),
    );
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    await _settingsService.saveApiKey(_apiKeyController.text);
    setState(() => _isTesting = true);

    try {
      await _movieService.searchMovie(
        title: 'Inception',
        apiKey: _apiKeyController.text.trim(),
      );

      if (!mounted) return;
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
                  Semantics(
                    textField: true,
                    label: 'Chave da API OMDb',
                    hint: 'Digite a sua chave de API e salve para usar na busca',
                    child: TextFormField(
                      controller: _apiKeyController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'API key (OMDb)',
                        hintText: 'Exemplo: abcd1234',
                        helperText: 'A chave é salva apenas localmente no dispositivo.',
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
                    hint: 'Testa se a API key consegue consultar a API de filmes',
                    child: OutlinedButton.icon(
                      onPressed: _isTesting ? null : _testConnection,
                      icon: const Icon(Icons.wifi_tethering),
                      label: Text(_isTesting ? 'Testando...' : 'Testar conexão'),
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
