import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/colors/app_colors.dart';
import '../../../shared/components/app_text_field.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../controller/home_controller.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.cepController,
    required this.stateController,
    required this.cityController,
    required this.streetController,
    required this.onSearch,
    required this.onNewSearch,
  });

  final SearchMode mode;
  final ValueChanged<SearchMode> onModeChanged;
  final TextEditingController cepController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  final TextEditingController streetController;
  final VoidCallback onSearch;
  final VoidCallback onNewSearch;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppMetrics.radius),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<SearchMode>(
              segments: const [
                ButtonSegment(
                  value: SearchMode.cep,
                  label: Text('Por CEP'),
                  icon: Icon(Icons.pin_drop_outlined),
                ),
                ButtonSegment(
                  value: SearchMode.address,
                  label: Text('Por endereço'),
                  icon: Icon(Icons.signpost_outlined),
                ),
              ],
              selected: {mode},
              onSelectionChanged: (selected) => onModeChanged(selected.first),
            ),
            const SizedBox(height: AppMetrics.spacingMd),
            if (mode == SearchMode.cep)
              _buildCepFields()
            else
              _buildAddressFields(),
            const SizedBox(height: AppMetrics.spacingMd),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onNewSearch,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Nova consulta'),
                  ),
                ),
                const SizedBox(width: AppMetrics.spacingSm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onSearch,
                    icon: const Icon(Icons.search),
                    label: const Text('Consultar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCepFields() {
    return AppTextField(
      controller: cepController,
      label: 'CEP',
      hint: '88010000',
      icon: Icons.markunread_mailbox_outlined,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.search,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      onSubmitted: (_) => onSearch(),
    );
  }

  Widget _buildAddressFields() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 96,
              child: AppTextField(
                controller: stateController,
                label: 'UF',
                hint: 'SC',
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                  LengthLimitingTextInputFormatter(2),
                ],
              ),
            ),
            const SizedBox(width: AppMetrics.spacingSm),
            Expanded(
              child: AppTextField(
                controller: cityController,
                label: 'Cidade',
                hint: 'Florianópolis',
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppMetrics.spacingSm),
        AppTextField(
          controller: streetController,
          label: 'Logradouro (completo ou parte)',
          hint: 'Felipe Schmidt',
          icon: Icons.signpost_outlined,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => onSearch(),
        ),
      ],
    );
  }
}
