import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_problems.dart';
import '../../../models/problem_report.dart';
import '../../../widgets/map_marker.dart';

/// Centro de Jacareí — usado como posição padrão do mapa
const LatLng kJacareiCenter = LatLng(-23.3053, -45.9658);
const double kDefaultZoom = 15.0;

/// Widget do mapa real com tiles CartoDB Positron (estilo clean)
/// Mantém a mesma interface do mapa mock para integração transparente
class MapView extends StatelessWidget {
  final String? selectedProblemId;
  final ValueChanged<ProblemReport>? onMarkerTap;

  // ── Location Picker mode ──────────────────────────────────
  final bool isSelectionMode;
  final MapController? mapController;
  final void Function(MapEvent)? onMapEvent;

  const MapView({
    super.key,
    this.selectedProblemId,
    this.onMarkerTap,
    this.isSelectionMode = false,
    this.mapController,
    this.onMapEvent,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: kJacareiCenter,
        initialZoom: kDefaultZoom,
        minZoom: 12.0,
        maxZoom: 18.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
        backgroundColor: AppColors.mapBackground,
        onMapEvent: onMapEvent,
      ),
      children: [
        // ── Tile Layer — CartoDB Positron (estilo clean/minimalista) ──
        ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            // Dessatura levemente e ajusta brilho para tom pastel
            0.85, 0.10, 0.05, 0, 10,
            0.05, 0.85, 0.10, 0, 10,
            0.05, 0.10, 0.85, 0, 10,
            0,    0,    0,    1,  0,
          ]),
          child: TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'com.reconstroijacarei.app',
            maxZoom: 19,
          ),
        ),

        // ── Marcadores (ocultos em modo seleção) ────────────────────
        if (!isSelectionMode)
          MarkerLayer(
            markers: mockProblems.map((problem) {
              return Marker(
                point: LatLng(problem.latitude, problem.longitude),
                width: 48,
                height: 56,
                alignment: Alignment.topCenter,
                child: MapMarker(
                  problem: problem,
                  isSelected: problem.id == selectedProblemId,
                  onTap: () => onMarkerTap?.call(problem),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
