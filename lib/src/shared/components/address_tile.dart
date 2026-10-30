import 'package:flutter/material.dart';

import '../../modules/home/model/address_model.dart';
import '../colors/app_colors.dart';
import '../metrics/app_metrics.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    super.key,
    required this.address,
    this.onTap,
    this.showConsultedAt = false,
  });

  final AddressModel address;
  final VoidCallback? onTap;
  final bool showConsultedAt;

  @override
  Widget build(BuildContext context) {
    final title = address.street.isEmpty
        ? address.cityAndState
        : address.street;
    final details = [
      'CEP ${address.cep}',
      if (address.neighborhood.isNotEmpty) address.neighborhood,
      if (address.street.isNotEmpty) address.cityAndState,
      if (showConsultedAt) 'Consultado em ${_formatDate(address.consultedAt)}',
    ];

    return Card(
      elevation: 0,
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: AppMetrics.spacingSm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppMetrics.radius),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.place_outlined, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(details.join('\n')),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      ),
    );
  }

  String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} '
        'às ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }
}
