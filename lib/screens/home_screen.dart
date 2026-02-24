import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/settings_service.dart';
import '../services/share_service.dart';
import '../utils/share_text_builder.dart';
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
  String _appVersion = '1.0.0+1';

  @override
  void initState() {
    super.initState();
    _movieService = widget._movieService ?? MovieService();
    _settingsService = widget._settingsService ?? SettingsService();
    _shareService = widget._shareService ?? ShareService();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _appVersion = packageInfo.buildNumber.isNotEmpty
            ? '${packageInfo.version}+${packageInfo.buildNumber}'
            : packageInfo.version;
      });
    } catch (_) {
      // Mantém versão padrão em ambientes de teste sem plugin registrado.
    }
  }

  @override
  void dispose() {
    _movieController.dispose();
    super.dispose();
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

  Future<void> _shareMovie() async {
    final movie = _movie;
    if (movie == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Busque um filme para habilitar o compartilhamento.'),
        ),
      );
      return;
    }

    final shareText = buildMovieShareText(movie);
    await _shareService.shareText(shareText);
  }

  Future<void> _openSettings() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
  }

  Future<void> _openAboutDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre'),
        content: Semantics(
          liveRegion: true,
          label: 'Informações do aplicativo',
          child: Text(
            'Sinopse de Filmes\nVersão: $_appVersion\nAutor: Paulo Filho',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sinopse de Filmes'),
        actions: [
          Semantics(
            button: true,
            label: 'Sobre o aplicativo',
            hint: 'Abre uma janela com nome, versão e autoria do app',
            child: IconButton(
              tooltip: 'Sobre',
              onPressed: _openAboutDialog,
              icon: const Icon(Icons.info_outline),
            ),
          ),
          Semantics(
            button: true,
            label: 'Compartilhar sinopse',
            hint: 'Compartilha o resultado por WhatsApp, Telegram ou outro app',
            child: IconButton(
              tooltip: 'Compartilhar sinopse',
              onPressed: _shareMovie,
              icon: const Icon(Icons.share),
            ),
          ),
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
