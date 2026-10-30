import 'package:flutter/material.dart';

import '../../../shared/components/address_tile.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../model/address_model.dart';

class AddressList extends StatelessWidget {
  const AddressList({
    super.key,
    required this.addresses,
    required this.onSelected,
  });

  final List<AddressModel> addresses;
  final ValueChanged<AddressModel> onSelected;

  @override
  Widget build(BuildContext context) {
    final label = addresses.length == 1
        ? '1 endereço encontrado'
        : '${addresses.length} endereços encontrados';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const Text('Toque em um endereço para selecioná-lo.'),
        const SizedBox(height: AppMetrics.spacingSm),
        for (final address in addresses)
          AddressTile(address: address, onTap: () => onSelected(address)),
      ],
    );
  }
}
