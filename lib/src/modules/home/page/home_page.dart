import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/components/loading_overlay.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../components/address_list.dart';
import '../components/empty_search.dart';
import '../components/last_address.dart';
import '../components/search_form.dart';
import '../controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.controller});

  final HomeController controller;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _cepController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  late final ReactionDisposer _errorReaction;

  HomeController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.loadLastAddress();
    _errorReaction = reaction<String?>(
      (_) => controller.errorMessage,
      _showError,
    );
  }

  @override
  void dispose() {
    _errorReaction();
    _cepController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('FastLocation'),
            actions: [
              IconButton(
                tooltip: 'Histórico de consultas',
                icon: const Icon(Icons.history),
                onPressed: _openHistory,
              ),
            ],
          ),
          floatingActionButton: Observer(builder: (_) => _buildRouteButton()),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppMetrics.spacingMd,
                AppMetrics.spacingMd,
                AppMetrics.spacingMd,
                96,
              ),
              children: [
                Observer(
                  builder: (_) => SearchForm(
                    mode: controller.mode,
                    onModeChanged: controller.changeMode,
                    cepController: _cepController,
                    stateController: _stateController,
                    cityController: _cityController,
                    streetController: _streetController,
                    onSearch: _search,
                    onNewSearch: _newSearch,
                  ),
                ),
                const SizedBox(height: AppMetrics.spacingMd),
                Observer(builder: (_) => _buildResults()),
              ],
            ),
          ),
        ),
        Observer(
          builder: (_) => controller.isLoading
              ? const LoadingOverlay(message: 'Consultando o ViaCEP...')
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final lastAddress = controller.lastAddress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (controller.notFound)
          EmptySearch(
            title: 'Nenhum endereço encontrado',
            message: controller.mode == SearchMode.cep
                ? 'Confira o CEP digitado e tente novamente.'
                : 'Tente outro trecho do logradouro ou confira a cidade e a UF.',
          ),
        if (controller.hasResults) ...[
          AddressList(
            addresses: controller.results.toList(),
            onSelected: controller.selectResult,
          ),
          const SizedBox(height: AppMetrics.spacingMd),
        ],
        if (lastAddress != null)
          LastAddress(address: lastAddress)
        else if (!controller.notFound && !controller.hasResults)
          const EmptySearch(
            icon: Icons.travel_explore,
            title: 'Nenhuma consulta ainda',
            message: 'Busque um endereço pelo CEP ou um CEP pelo endereço.',
          ),
      ],
    );
  }

  Widget _buildRouteButton() {
    if (controller.lastAddress == null) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton.extended(
      onPressed: controller.canTraceRoute ? controller.traceRoute : null,
      icon: controller.isTracingRoute
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.directions),
      label: const Text('Traçar rota'),
    );
  }

  void _search() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (controller.mode == SearchMode.cep) {
      controller.searchByCep(_cepController.text);
      return;
    }
    controller.searchByAddress(
      state: _stateController.text,
      city: _cityController.text,
      street: _streetController.text,
    );
  }

  void _newSearch() {
    _cepController.clear();
    _stateController.clear();
    _cityController.clear();
    _streetController.clear();
    controller.newSearch();
  }

  Future<void> _openHistory() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Navigator.of(context).pushNamed(AppRoutes.history);
    controller.loadLastAddress();
  }

  void _showError(String? message) {
    if (message == null || !mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
