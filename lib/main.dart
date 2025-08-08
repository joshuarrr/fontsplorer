import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

// Use a root navigator key so modal sheets always open regardless of local context
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// Domain model representing an entry of title + artist with style settings.
class FontCardSpec {
  const FontCardSpec({
    required this.family,
    required this.titleSize,
    required this.fontWeight,
    required this.letterSpacing,
    required this.lineHeight,
    required this.title,
    required this.artist,
  });

  final String family;
  final double titleSize; // in logical pixels
  final FontWeight fontWeight;
  final double letterSpacing; // px
  final double lineHeight; // fractional (eg 1.0 = 100%)
  final String title;
  final String artist;
}

enum BrowserMode { list, card }

const String kDefaultTitle = 'Breathe\n(In The Air)';
const String kDefaultArtist = 'Pink Floyd';

// Hardcoded font specs adapted from font-specifications.css
final List<FontCardSpec> kSpecs = <FontCardSpec>[
  FontCardSpec(
    family: 'Scorn',
    titleSize: 50,
    fontWeight: FontWeight.w400,
    letterSpacing: 2.5,
    lineHeight: 1.0,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'KyivTypeTitling',
    titleSize: 56,
    fontWeight: FontWeight.w800,
    letterSpacing: -2.8,
    lineHeight: 1.0,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'Starway',
    titleSize: 62,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.62,
    lineHeight: 0.85,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'Danfo',
    titleSize: 54,
    fontWeight: FontWeight.w400,
    letterSpacing: 2.7,
    lineHeight: 1.0,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'PlaywriteUSModern',
    titleSize: 49,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.98,
    lineHeight: 1.2,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'Grisha',
    titleSize: 54,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.08,
    lineHeight: 1.1,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'PlaywriteUSTrad',
    titleSize: 42,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.84,
    lineHeight: 1.3,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'Gotfridus',
    titleSize: 42,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.84,
    lineHeight: 1.25,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'Sniglet',
    titleSize: 49,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.98,
    lineHeight: 1.1,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'Star Fox/Starwing',
    titleSize: 34,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.68,
    lineHeight: 1.6,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'Tektur',
    titleSize: 46,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.3,
    lineHeight: 1.1,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'InstrumentSerif',
    titleSize: 62,
    fontWeight: FontWeight.w400,
    letterSpacing: 3.1,
    lineHeight: 1.0,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'Lato',
    titleSize: 50,
    fontWeight: FontWeight.w500,
    letterSpacing: 2.5,
    lineHeight: 1.1,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
  FontCardSpec(
    family: 'MontserratAlternates',
    titleSize: 46,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.92,
    lineHeight: 1.1,
    title: kDefaultTitle,
    artist: kDefaultArtist,
  ),
];

void main() {
  runApp(const FontSplorerApp());
}

class FontSplorerApp extends StatefulWidget {
  const FontSplorerApp({super.key});

  @override
  State<FontSplorerApp> createState() => _FontSplorerAppState();
}

class _FontSplorerAppState extends State<FontSplorerApp> {
  BrowserMode _mode = BrowserMode.card;
  int? _selectedIndex; // For dimming non-selected items when the sheet is open
  bool _showSettings = false;
  double _scale = 1.0; // 0.7 – 1.3

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'fontsplorer',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF131016),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF131016),
      ),
      home: Scaffold(
        body: Stack(
          children: [
            // App background gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1A131F), Color(0xFF271C2E)],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: _mode == BrowserMode.list
                  ? _FontListView(
                      specs: kSpecs,
                      scale: _scale,
                      selectedIndex: _selectedIndex,
                      onTapSpec: (int index, FontCardSpec spec) async {
                        setState(() => _selectedIndex = index);
                        await _showSpecSheet(context, spec);
                        if (mounted) setState(() => _selectedIndex = null);
                      },
                    )
                  : _FontCardPager(
                      specs: kSpecs,
                      scale: _scale,
                      selectedIndex: _selectedIndex,
                      onTapSpec: (int index, FontCardSpec spec) async {
                        setState(() => _selectedIndex = index);
                        await _showSpecSheet(context, spec);
                        if (mounted) setState(() => _selectedIndex = null);
                      },
                    ),
            ),
            const _TopScrim(),
            const _BottomScrim(),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                minimum: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showSettings)
                      _ScaleSlider(
                        value: _scale,
                        onChanged: (double v) => setState(() => _scale = v),
                      ),
                    _ModeSegmentedControl(
                      mode: _mode,
                      showSettings: _showSettings,
                      onChanged: (BrowserMode m) => setState(() {
                        _mode = m;
                        _showSettings = false;
                      }),
                      onToggleSettings: () =>
                          setState(() => _showSettings = !_showSettings),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeSegmentedControl extends StatelessWidget {
  const _ModeSegmentedControl({
    required this.mode,
    required this.onChanged,
    required this.onToggleSettings,
    required this.showSettings,
  });
  final BrowserMode mode;
  final ValueChanged<BrowserMode> onChanged;
  final VoidCallback onToggleSettings;
  final bool showSettings;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0x0DFFFFFF),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white24, width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _IconTab(
                icon: Icons.view_list,
                selected: mode == BrowserMode.list,
                onTap: () => onChanged(BrowserMode.list),
              ),
              const SizedBox(width: 18),
              _IconTab(
                icon: Icons.view_agenda,
                selected: mode == BrowserMode.card,
                onTap: () => onChanged(BrowserMode.card),
              ),
              const SizedBox(width: 18),
              _IconTab(
                icon: Icons.tune, // sliders icon
                selected: showSettings,
                onTap: onToggleSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconTab extends StatelessWidget {
  const _IconTab({
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? Colors.white : Colors.white54;
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 20, color: color),
    );
  }
}

class _ScaleSlider extends StatelessWidget {
  const _ScaleSlider({required this.value, required this.onChanged});
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x0DFFFFFF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white24, width: 1.2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.remove, color: Colors.white54, size: 18),
                SizedBox(
                  width: 180,
                  child: CupertinoSlider(
                    min: 0.7,
                    max: 1.3,
                    value: value.clamp(0.7, 1.3),
                    onChanged: onChanged,
                  ),
                ),
                const Icon(Icons.add, color: Colors.white54, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopScrim extends StatelessWidget {
  const _TopScrim();
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 160,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A131F), Color(0x001A131F)],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomScrim extends StatelessWidget {
  const _BottomScrim();
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFF271C2E), Color(0x00271C2E)],
            ),
          ),
        ),
      ),
    );
  }
}

class _FontCard extends StatelessWidget {
  const _FontCard({required this.spec, this.onTap});
  final FontCardSpec spec;
  final VoidCallback? onTap;

  TextStyle _titleStyle() {
    return TextStyle(
      fontFamily: spec.family,
      fontSize: spec.titleSize,
      fontWeight: spec.fontWeight,
      height: spec.lineHeight,
      letterSpacing: spec.letterSpacing,
      color: Colors.white,
    );
  }

  TextStyle _artistStyle() {
    return const TextStyle(
      fontFamily: 'MuseoModerno',
      fontSize: 30,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.6,
      color: Colors.white,
      fontVariations: <ui.FontVariation>[ui.FontVariation('wght', 400)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(spec.title, textAlign: TextAlign.center, style: _titleStyle()),
          const SizedBox(height: 10), // space between title and artist
          Text(spec.artist, textAlign: TextAlign.center, style: _artistStyle()),
        ],
      ),
    );
  }
}

class _FontListView extends StatelessWidget {
  const _FontListView({
    required this.specs,
    required this.scale,
    this.selectedIndex,
    this.onTapSpec,
  });
  final List<FontCardSpec> specs;
  final double scale;
  final int? selectedIndex;
  final void Function(int index, FontCardSpec spec)? onTapSpec;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 200, 24, 200),
      itemCount: specs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 48),
      itemBuilder: (context, index) {
        final FontCardSpec spec = specs[index];
        final bool isDimmed = selectedIndex != null && selectedIndex != index;
        return Opacity(
          opacity: isDimmed ? 0.2 : 1.0,
          child: Transform.scale(
            scale: scale,
            child: _FontCard(
              spec: spec,
              onTap: () => onTapSpec?.call(index, spec),
            ),
          ),
        );
      },
    );
  }
}

class _FontCardPager extends StatelessWidget {
  const _FontCardPager({
    required this.specs,
    required this.scale,
    this.selectedIndex,
    this.onTapSpec,
  });
  final List<FontCardSpec> specs;
  final double scale;
  final int? selectedIndex;
  final void Function(int index, FontCardSpec spec)? onTapSpec;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: specs.length,
      itemBuilder: (context, index) {
        final bool isDimmed = selectedIndex != null && selectedIndex != index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Opacity(
            opacity: isDimmed ? 0.25 : 1.0,
            child: Transform.scale(
              scale: scale,
              child: _FontCard(
                spec: specs[index],
                onTap: () => onTapSpec?.call(index, specs[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showSpecSheet(BuildContext context, FontCardSpec spec) async {
  return showModalBottomSheet<void>(
    context: rootNavigatorKey.currentContext ?? context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    isScrollControlled: true,
    showDragHandle: false,
    builder: (BuildContext ctx) {
      return FractionallySizedBox(
        heightFactor: 0.4,
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(44),
            topRight: Radius.circular(44),
          ),
          child: Container(
            color: const Color(0xFF1A131F),
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  spec.family,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'MuseoModerno',
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontVariations: <ui.FontVariation>[
                      ui.FontVariation('wght', 400),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SpecRow(label: 'size', value: _px(spec.titleSize)),
                _SpecRow(
                  label: 'letter-spacing',
                  value: _px(spec.letterSpacing),
                ),
                _SpecRow(
                  label: 'line-height',
                  value: _percent(spec.lineHeight),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
    },
  );
}

String _px(double value) {
  final String sign = value < 0 ? '-' : '';
  final double absVal = value.abs();
  // show whole numbers without decimals, otherwise 2 decimals
  final String digits = absVal == absVal.roundToDouble()
      ? absVal.toStringAsFixed(0)
      : absVal.toStringAsFixed(2);
  return '$sign${digits}px';
}

String _percent(double fraction) {
  return '${(fraction * 100).toStringAsFixed(0)}%';
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'MuseoModerno',
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontVariations: <ui.FontVariation>[
                  ui.FontVariation('wght', 400),
                ],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'MuseoModerno',
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontVariations: <ui.FontVariation>[
                  ui.FontVariation('wght', 400),
                ],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
