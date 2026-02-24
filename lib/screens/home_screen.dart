import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/settings_service.dart';
import '../services/share_service.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    MovieService? movieService,
    SettingsService? settingsService,
    ShareService? shareService,
  }) : _movieService = movieService,
       _settingsService = settingsService,
       _shareService = shareService;

  final MovieService? _movieService;
  final SettingsService? _settingsService;
  final ShareService? _shareService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _movieController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final MovieService _movieService;
  late final SettingsService _settingsService;
  late final ShareService _shareService;

  bool _isLoading = false;
  String? _errorMessage;
  Movie? _movie;

  @override
  void initState() {
    super.initState();
    _movieService = widget._movieService ?? MovieService();
    _settingsService = widget._settingsService ?? SettingsService();
    _shareService = widget._shareService ?? const ShareService();
  }

  @override
  void dispose() {
    _movieController.dispose();
    super.dispose();
  }

  String _buildShareText(Movie movie) {
    return '🎬 ${movie.title} (${movie.year})\n\n📝 Sinopse:\n${movie.plot}';
  }

  Future<void> _shareSynopsis() async {
    if (_movie == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Busque um filme antes de compartilhar.'),
        ),
      );
      return;
    }

    await _shareService.shareText(_buildShareText(_movie!));
  }

  Future<void> _searchMovie() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _movie = null;
    });

    final apiKey = await _settingsService.getApiKey();
    if (apiKey.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Configure sua chave de API na tela de Configurações.';
      });
      return;
    }

    try {
      final result = await _movieService.searchMovie(
        title: _movieController.text.trim(),
        apiKey: apiKey,
      );

      if (!mounted) return;
      setState(() {
        _movie = result;
      });
    } on MovieServiceException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openSettings() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sinopse de Filmes'),
        actions: [
          Semantics(
            button: true,
            label: 'Abrir configurações',
            hint: 'Abre a tela para configurar a chave da API',
            child: IconButton(
              tooltip: 'Configurações',
              onPressed: _openSettings,
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: FocusTraversalGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    textField: true,
                    sortKey: const OrdinalSortKey(1),
                    label: 'Nome do filme',
                    hint: 'Digite o título do filme para buscar a sinopse',
                    child: TextFormField(
                      controller: _movieController,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (_) => _searchMovie(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome do filme',
                        hintText: 'Exemplo: Interestelar',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o nome do filme.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Semantics(
                    button: true,
                    sortKey: const OrdinalSortKey(2),
                    label: 'Buscar sinopse',
                    hint: 'Busca o filme informado e exibe os detalhes',
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _searchMovie,
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar sinopse'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Semantics(
                    button: true,
                    sortKey: const OrdinalSortKey(3),
                    label: 'Compartilhar sinopse',
                    hint:
                        'Compartilha título, ano e sinopse em aplicativos como WhatsApp e Telegram',
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _shareSynopsis,
                      icon: const Icon(Icons.share),
                      label: const Text('Compartilhar'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    Semantics(
                      label: 'Carregando dados do filme',
                      liveRegion: true,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  if (_errorMessage != null)
                    Semantics(
                      liveRegion: true,
                      label: 'Mensagem de erro',
                      child: Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                        ),
                      ),
                    ),
                  if (_movie != null)
                    Semantics(
                      liveRegion: true,
                      label: 'Resultado da busca',
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _movie!.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text('Ano: ${_movie!.year}'),
                              const SizedBox(height: 12),
                              Text(
                                _movie!.plot,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
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
