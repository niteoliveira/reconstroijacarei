import 'dart:ui';

/// Endereços mock divididos em uma grade 3x3 do mapa
/// Usado pelo location picker para simular geocodificação reversa
class MockAddressRegion {
  final Rect region;
  final String address;
  final String neighborhood;

  const MockAddressRegion({
    required this.region,
    required this.address,
    required this.neighborhood,
  });

  String get fullAddress => '$address — $neighborhood';
}

/// Grade de regiões → endereços
/// O mapa mock tem coordenadas relativas (0.0 a 1.0)
/// Dividimos em 3x3 = 9 setores
final List<MockAddressRegion> mockAddressRegions = [
  // ── Linha superior ────────────────────────────────────────────
  const MockAddressRegion(
    region: Rect.fromLTWH(0, 0, 0.33, 0.33),
    address: 'Av. Presidente Vargas, 500',
    neighborhood: 'Jardim Paraíso',
  ),
  const MockAddressRegion(
    region: Rect.fromLTWH(0.33, 0, 0.34, 0.33),
    address: 'R. Sete de Setembro, 120',
    neighborhood: 'Centro',
  ),
  const MockAddressRegion(
    region: Rect.fromLTWH(0.67, 0, 0.33, 0.33),
    address: 'R. Cel. João Cursino, 85',
    neighborhood: 'Vila Machado',
  ),

  // ── Linha central ─────────────────────────────────────────────
  const MockAddressRegion(
    region: Rect.fromLTWH(0, 0.33, 0.33, 0.34),
    address: 'R. Alfredo Bueno, 155',
    neighborhood: 'Centro',
  ),
  const MockAddressRegion(
    region: Rect.fromLTWH(0.33, 0.33, 0.34, 0.34),
    address: 'R. Barão de Jacarehy, 200',
    neighborhood: 'Centro',
  ),
  const MockAddressRegion(
    region: Rect.fromLTWH(0.67, 0.33, 0.33, 0.34),
    address: 'Av. Major Acácio, 340',
    neighborhood: 'Vila Maria',
  ),

  // ── Linha inferior ────────────────────────────────────────────
  const MockAddressRegion(
    region: Rect.fromLTWH(0, 0.67, 0.33, 0.33),
    address: 'R. São João, 310',
    neighborhood: 'Jardim das Flores',
  ),
  const MockAddressRegion(
    region: Rect.fromLTWH(0.33, 0.67, 0.34, 0.33),
    address: 'Praça Conselheiro Rodrigues Alves',
    neighborhood: 'Centro',
  ),
  const MockAddressRegion(
    region: Rect.fromLTWH(0.67, 0.67, 0.33, 0.33),
    address: 'R. Barão do Rio Branco, 70',
    neighborhood: 'Jardim Paulista',
  ),
];

/// Retorna o endereço mock baseado na posição relativa no mapa
/// [relativeX] e [relativeY] vão de 0.0 a 1.0
String getAddressForPosition(double relativeX, double relativeY) {
  // Clamp para manter dentro dos limites
  final x = relativeX.clamp(0.0, 0.999);
  final y = relativeY.clamp(0.0, 0.999);

  for (final region in mockAddressRegions) {
    if (region.region.contains(Offset(x, y))) {
      return region.fullAddress;
    }
  }

  // Fallback: centro
  return mockAddressRegions[4].fullAddress;
}
