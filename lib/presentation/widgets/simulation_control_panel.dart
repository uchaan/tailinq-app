import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/location_simulator.dart';
import '../providers/simulation_provider.dart';

class SimulationControlPanel extends ConsumerWidget {
  const SimulationControlPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulationState = ref.watch(simulationProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: simulationState.isEnabled
            ? Colors.orange.shade50
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: simulationState.isEnabled
              ? Colors.orange.shade300
              : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Icon(
                Icons.science_outlined,
                size: 18,
                color: simulationState.isEnabled ? Colors.orange : Colors.grey,
              ),
              const SizedBox(width: 8),
              const Text(
                'Simulation Mode',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Switch(
                value: simulationState.isEnabled,
                onChanged: (_) {
                  ref.read(simulationProvider.notifier).toggleEnabled();
                },
                activeTrackColor: Colors.orange.shade200,
                activeThumbColor: Colors.orange,
              ),
            ],
          ),

          if (simulationState.isEnabled) ...[
            const SizedBox(height: 12),

            // 시나리오 선택
            const Text(
              'Scenario',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: SimulationScenario.values.map((scenario) {
                  final isSelected = simulationState.scenario == scenario;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(scenario.label),
                      selected: isSelected,
                      onSelected: (_) {
                        ref.read(simulationProvider.notifier).setScenario(scenario);
                      },
                      selectedColor: Colors.orange.shade200,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.orange.shade900 : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      avatar: Icon(
                        _getScenarioIcon(scenario),
                        size: 16,
                        color: isSelected ? Colors.orange.shade900 : Colors.grey,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // 시작/일시정지 버튼
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(simulationProvider.notifier).toggleRunning();
                    },
                    icon: Icon(
                      simulationState.isRunning ? Icons.pause : Icons.play_arrow,
                      size: 18,
                    ),
                    label: Text(simulationState.isRunning ? 'Pause' : 'Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          simulationState.isRunning ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: simulationState.isRunning
                      ? () {
                          ref.read(simulationProvider.notifier).toggleEnabled();
                        }
                      : null,
                  icon: const Icon(Icons.stop, size: 18),
                  label: const Text('Stop'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ],
            ),

            // 상태 표시
            if (simulationState.isRunning) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withAlpha(128),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Simulating: ${simulationState.scenario.description}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  IconData _getScenarioIcon(SimulationScenario scenario) {
    switch (scenario) {
      case SimulationScenario.idle:
        return Icons.home;
      case SimulationScenario.walking:
        return Icons.directions_walk;
      case SimulationScenario.running:
        return Icons.directions_run;
      case SimulationScenario.exploring:
        return Icons.explore;
      case SimulationScenario.returning:
        return Icons.keyboard_return;
    }
  }
}
