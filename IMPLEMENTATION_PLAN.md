# Reconstrói Jacareí — Plano de Implementação de Interfaces

## O que é o projeto

**Reconstrói Jacareí** é um aplicativo mobile desenvolvido em Flutter que permite cidadãos reportarem problemas urbanos (buracos, calçadas quebradas, sinalização danificada, etc.) diretamente no mapa da cidade. A inspiração visual é o **Waze** — mapa como tela principal, marcadores coloridos por status, fluxo rápido com poucos toques.

> **Escopo deste plano**: apenas as **interfaces** (UI/UX), sem integração com backend, autenticação real ou mapas reais. Dados são estáticos/mock. Funcionalidades serão implementadas em uma fase futura.

---

## O que entendi das telas (baseado nos mockups)

| Tela | Descrição |
|---|---|
| **Home — Mapa** | Tela fullscreen de mapa com barra de pesquisa flutuante no topo, FABs `+` e localização no canto inferior direito, marcadores coloridos por status |
| **Bottom Sheet — Problema existente** | Sobe ao tocar em marcador, mostra: tipo, status (badge), localização, data, autor, gravidade, descrição, contador de confirmações e botão "Marcar como Resolvido" |
| **Bottom Sheet — Confirmação rápida** | Card pequeno no rodapé com contagem de confirmações e botões "Sim / Não" para confirmar se o problema persiste |
| **Tela de Pesquisa** | Tela individual com campo ativo, histórico de buscas recentes e sugestões de endereços |
| **Tela de Perfil** | Cabeçalho com avatar, nome e e-mail, badge "Contribuidor Ativo", menu de Configurações e botão Sair |

**Sistema de cores dos marcadores** (estilo Waze):
- 🔴 Vermelho (`#E53935`) — Problema ativo (urgente)
- 🟡 Amarelo (`#FFA000`) — Em análise
- 🟢 Verde (`#43A047`) — Resolvido
- 🔵 Azul (`#1A73E8`) — Cor primária (ações, avatar, FAB principal)

---

## Princípios norteadores

- **Separação de responsabilidades**: cada widget faz uma coisa só
- **Dados desacoplados da UI**: modelos e dados mock em camada própria, fáceis de substituir por API real depois
- **Componentes reutilizáveis**: Design System próprio, sem duplicação de estilos
- **Incrementalidade**: cada sprint entrega algo visualmente funcional e testável
- **Sem estado global prematuro**: `setState` enquanto não há lógica de negócio; preparar estrutura para `Provider`/`Riverpod` depois

---

## Arquitetura de pastas proposta

```
lib/
├── main.dart                    # Entry point, MaterialApp + ThemeData
├── core/
│   ├── theme/
│   │   ├── app_colors.dart      # Paleta de cores centralizada
│   │   ├── app_text_styles.dart # Tipografia (Google Fonts: Inter)
│   │   └── app_theme.dart       # ThemeData Material 3
│   └── constants/
│       └── app_strings.dart     # Strings do app (PT-BR)
├── models/
│   └── problem_report.dart      # Modelo de dados de um problema
├── data/
│   └── mock_problems.dart       # Lista de problemas fictícios para UI
├── widgets/
│   ├── map_marker.dart          # Marcador colorido customizado
│   ├── problem_status_badge.dart# Badge colorido (Ativo/Em análise/Resolvido)
│   ├── floating_search_bar.dart # Barra de pesquisa flutuante
│   └── bottom_sheet_handle.dart # Handle visual do bottom sheet
└── screens/
    ├── home/
    │   ├── home_screen.dart          # Stack: mapa + overlays
    │   ├── widgets/
    │   │   ├── map_view.dart              # Widget do mapa (mock com Container)
    │   │   ├── problem_detail_sheet.dart  # Bottom sheet problema existente
    │   │   ├── report_problem_sheet.dart  # Bottom sheet novo problema
    │   │   └── quick_confirm_card.dart    # Card de confirmação rápida
    ├── search/
    │   └── search_screen.dart
    └── profile/
        └── profile_screen.dart
```

> **Por que essa estrutura?** Separa `core` (design system), `models` (dados), `widgets` (componentes genéricos) e `screens` (páginas). É a estrutura recomendada para Flutter escalável — fácil de migrar para feature-first no futuro.

---

## Dependências a adicionar no `pubspec.yaml`

| Pacote | Motivo |
|---|---|
| `google_fonts` | Tipografia Inter (sem precisar de assets locais) |
| `flutter_svg` *(opcional)* | Se forem usados ícones SVG customizados |

> Nenhuma dependência de mapa real nesta fase — o mapa será um `Container` com cor de fundo e grade estilizados simulando o visual Waze.

---

## Plano de Sprints Incrementais

### Sprint 0 — Foundation (Design System)
**Objetivo:** Tudo compilando com o tema correto. Base visual para todas as telas.

Arquivos criados:
- `core/theme/app_colors.dart` — todas as cores
- `core/theme/app_text_styles.dart` — estilos tipográficos com Inter
- `core/theme/app_theme.dart` — `ThemeData` Material 3 com `useMaterial3: true`
- `core/constants/app_strings.dart` — strings em PT-BR
- `models/problem_report.dart` — modelo `ProblemReport` (tipo, status, localização, data, autor, gravidade, descrição, confirmações)
- `data/mock_problems.dart` — 3–5 problemas mock para visualizar no mapa
- `main.dart` atualizado com tema e rota para `HomeScreen`

**Critério de aceite:** `flutter run` sem erros, tela inicial com fundo de mapa mock visível.

---

### Sprint 1 — Tela Home: Mapa + Overlays
**Objetivo:** Tela principal com todos os elementos visuais estáticos.

Arquivos criados/modificados:
- `screens/home/home_screen.dart` — `Stack` com camadas: mapa + barra superior + FABs
- `screens/home/widgets/map_view.dart` — mapa simulado (Container cinza-claro com grade), marcadores posicionados com `Positioned`
- `widgets/map_marker.dart` — marcador estilo Waze (círculo colorido com ícone branco, sombra)
- `widgets/floating_search_bar.dart` — barra arredondada com ícone de lupa, filtro e avatar

**Layout da Home:**
```
Stack (fullscreen)
├── MapView (fundo)
├── FloatingSearchBar (topo, padding: 16)
├── FAB "+" (canto inferior direito)
└── FAB localização (abaixo do FAB "+")
```

**Critério de aceite:** Tela visualmente fiel ao mockup 2, com marcadores vermelhos, amarelo e verde posicionados.

---

### Sprint 2 — Bottom Sheet: Detalhe de Problema
**Objetivo:** Ao tocar em um marcador, abre um `DraggableScrollableSheet` com detalhes.

Arquivos criados:
- `screens/home/widgets/problem_detail_sheet.dart`
- `widgets/problem_status_badge.dart`

**Conteúdo do sheet:**
- Título do tipo de problema (ex: "Problema na Sinalização")
- Badges de status + nível de gravidade
- Cards com: Localização, Data, Reportado por
- Campo de Nível de Gravidade e Descrição
- Banner "X pessoas confirmaram este problema"
- Botão primário verde "Marcar como Resolvido"

**Critério de aceite:** Tocar em qualquer marcador abre o sheet animado com dados mock, arrastável até 80% da tela.

---

### Sprint 3 — Bottom Sheet: Reportar Novo Problema
**Objetivo:** FAB "+" abre sheet para reportar problema.

Arquivo criado:
- `screens/home/widgets/report_problem_sheet.dart`

**Conteúdo:**
- Título "Reportar Problema"
- Endereço detectado (mock)
- `DropdownButton` para tipo: Buraco / Rachadura / Desnível / Sinalização / Outro
- `SegmentedButton` ou `Wrap` de `FilterChip` para gravidade: Baixa / Média / Alta
- `TextField` para descrição
- Botões "Confirmar" (azul) e "Cancelar" (outline)

**Critério de aceite:** FAB "+" abre sheet, usuário consegue selecionar tipo e gravidade visualmente.

---

### Sprint 4 — Card de Confirmação Rápida
**Objetivo:** Pequeno card flutuante no rodapé (mockup 1).

Arquivo criado:
- `screens/home/widgets/quick_confirm_card.dart`

**Conteúdo:**
- Texto "Calçada quebrada: 15 | A Calçada continua quebrada?"
- Botão "Sim" (verde) e "Não" (vermelho)

**Critério de aceite:** Card visível sobre o mapa no canto inferior, com os dois botões funcionais visualmente.

---

### Sprint 5 — Tela de Pesquisa
**Objetivo:** Tela dedicada de busca (abre ao tocar na barra de pesquisa).

Arquivo criado:
- `screens/search/search_screen.dart`

**Conteúdo:**
- Campo de texto ativo com `autofocus: true`
- Seção "Buscas Recentes" (lista com ícone de relógio)
- Seção "Sugestões" (lista com ícone de pin + endereço e bairro em cinza)

**Critério de aceite:** Tocar na barra de pesquisa da Home navega para `SearchScreen` com transição suave.

---

### Sprint 6 — Tela de Perfil
**Objetivo:** Tela de perfil acessível pelo avatar.

Arquivo criado:
- `screens/profile/profile_screen.dart`

**Conteúdo:**
- `AppBar` simples com seta voltar e título "Perfil"
- Card: avatar circular (azul), nome, email
- Banner "Contribuidor Ativo" (fundo azul claro, ícone de medalha)
- Lista: Configurações (com seta) + Sair (vermelho)
- Rodapé: "Versão 1.0.0 • Relatório de Problemas"

**Critério de aceite:** Tocar no avatar da Home navega para `ProfileScreen` com os dados mock.

---

### Sprint 7 — Polimento e Microinterações
**Objetivo:** Fazer o app "sentir" como um produto premium.

Melhorias:
- Animação de escala no marcador ao tocar (`AnimatedScale`)
- Transição de entrada do bottom sheet mais suave (curva `Curves.easeOutCubic`)
- `Snackbar` de confirmação ao tocar "Confirmar" no sheet de reporte
- Sombras nas FABs e barra de pesquisa mais pronunciadas
- Reviews dos espaçamentos e paddings para consistência com o Design System

---

## Verificação

### Verificação automatizada (Widget Tests)
Para cada sprint, criar um widget test mínimo em `test/`:

```bash
# Rodar todos os testes
flutter test

# Rodar teste de um arquivo específico
flutter test test/home_screen_test.dart
```

**Testes planejados:**
| Arquivo de teste | O que verifica |
|---|---|
| `test/theme_test.dart` | `AppColors` e `AppTextStyles` existem sem erros |
| `test/home_screen_test.dart` | `HomeScreen` renderiza sem overflow, `FloatingSearchBar` está presente |
| `test/problem_detail_sheet_test.dart` | Sheet renderiza título, badge de status e botão "Marcar como Resolvido" |
| `test/search_screen_test.dart` | `SearchScreen` renderiza seções "Buscas Recentes" e "Sugestões" |
| `test/profile_screen_test.dart` | `ProfileScreen` renderiza nome, email e opção "Sair" |

### Verificação visual manual (por sprint)
Após cada sprint, rodar no emulador Android com `flutter run`:

1. **Sprint 0:** Confirmar que o tema azul (#1A73E8) está aplicado e a tipografia Inter carregou
2. **Sprint 1:** Confirmar marcadores coloridos visíveis sobre o mapa mock
3. **Sprint 2:** Tocar em marcador → sheet sobe animado com dados corretos
4. **Sprint 3:** Tocar no "+" → sheet de reporte aparece com dropdown funcional
5. **Sprint 4:** Card de confirmação visível e botões Sim/Não respondem visualmente
6. **Sprint 5:** Barra de pesquisa → navega para tela de busca com histórico mock
7. **Sprint 6:** Avatar → navega para tela de perfil com dados mock
8. **Sprint 7:** Tocar em marcador → escala animada; confirmar → Snackbar aparece

> **Dispositivo alvo:** Android (emulador API 33+). A app **não** será testada em iOS nesta fase de interfaces.

---

## Sprint Real-Map — Mapa Real com Estilo Clean ✅

**Objetivo:** Substituir o mapa mock (CustomPainter) por um mapa real de Jacareí mantendo a identidade visual do app.

**O que foi feito:**
- Adicionadas dependências `flutter_map` e `latlong2`
- `ProblemReport` agora tem `latitude`/`longitude` reais de Jacareí
- `MapView` refatorado: usa `FlutterMap` com tiles **CartoDB Positron** (estilo minimalista clean)
- `ColorFilter.matrix` aplicado nos tiles para manter tom pastel/cinza do design original
- `MapController` integrado no `HomeScreen` — FAB de localização centraliza em Jacareí
- Location Picker usa eventos reais do mapa (`MapEventMoveStart`/`MapEventMoveEnd`) em vez do antigo sistema de `Offset`
- Marcadores `MapMarker` (com animação de pulso) continuam funcionando via `MarkerLayer`

**Tile Server:** `https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png` (gratuito, sem chave API)

---

## Sprint Pre-Backend — Preparação para integração com API ✅

**Objetivo:** Fechar todos os gaps do frontend antes de implementar o backend.

### Modelo completo ✅
- `ProblemReport` com `fromJson()` / `toJson()` / `toCreateJson()` / `copyWith()`
- Campos novos: `imageUrl`, `resolvedAt`, `resolvedBy`, `updatedAt`, `confirmedByCurrentUser`
- `FilterState` — modelo de filtros com `matches()`

### Gerenciamento de estado (Riverpod) ✅
- `problemsProvider` com ações: `addProblem`, `markResolved`, `confirmProblem`, `denyProblem`
- `filterProvider` com toggle de status/tipo/gravidade
- `filteredProblemsProvider` derivado (problemas × filtros)
- `authProvider` — stub de autenticação

### UI de Filtros ✅
- `FilterSheet` com multi-select chips + badge na FloatingSearchBar

### Fluxo de busca → mapa ✅
- SearchScreen retorna `{latitude, longitude}` via `context.pop()`

### Ações com estado real ✅
- ProblemDetailSheet e QuickConfirmCard usam provider
- ProfileScreen lê dados do auth + stats dos providers

### GoRouter ✅
- Rotas: `/`, `/search`, `/profile`, `/problem/:id`
- Deep link para push notifications

### Testes ✅ (18 testes passando)
- theme, providers, home, search, profile

---

## O que fica para a fase seguinte (fora deste plano)

- ~~Integração com mapa real~~ → ✅ Implementado (Sprint Real-Map)
- ~~Gerenciamento de estado~~ → ✅ Implementado (Riverpod)
- ~~Rotas nomeadas~~ → ✅ Implementado (GoRouter)
- **Autenticação** (Supabase/Firebase)
- **Banco de dados** de problemas (CRUD real)
- **Geolocalização** do usuário (`geolocator`)
- **Upload de fotos** no reporte
- **Push notifications**

