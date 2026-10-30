import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../shared/components/address_tile.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../../home/components/empty_search.dart';
import '../controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.controller});

  final HistoryController controller;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  HistoryController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de consultas'),
        actions: [
          Observer(
            builder: (_) => IconButton(
              tooltip: 'Limpar histórico',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: controller.isEmpty ? null : _confirmClear,
            ),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (controller.isEmpty) {
            return const Center(
              child: EmptySearch(
                icon: Icons.history,
                title: 'Histórico vazio',
                message: 'Os endereços consultados aparecem aqui.',
              ),
            );
          }

          final addresses = controller.addresses;
          return ListView.builder(
            padding: const EdgeInsets.all(AppMetrics.spacingMd),
            itemCount: addresses.length,
            itemBuilder: (_, index) =>
                AddressTile(address: addresses[index], showConsultedAt: true),
          );
        },
      ),
    );
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Limpar histórico?'),
        content: const Text('Todos os endereços consultados serão apagados.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await controller.clear();
    }
  }
}
