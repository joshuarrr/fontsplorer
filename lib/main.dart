import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            Positioned.fill(
              child: _mode == BrowserMode.list
                  ? _FontListView(
                      specs: kSpecs,
                      selectedIndex: _selectedIndex,
                      onTapSpec: (int index, FontCardSpec spec) async {
                        setState(() => _selectedIndex = index);
                        await _showSpecSheet(context, spec);
                        if (mounted) setState(() => _selectedIndex = null);
                      },
                    )
                  : _FontCardPager(
                      specs: kSpecs,
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
                child: _ModeSegmentedControl(
                  mode: _mode,
                  onChanged: (BrowserMode m) => setState(() => _mode = m),
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
  const _ModeSegmentedControl({required this.mode, required this.onChanged});
  final BrowserMode mode;
  final ValueChanged<BrowserMode> onChanged;

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
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: CupertinoSlidingSegmentedControl<BrowserMode>(
            backgroundColor: Colors.transparent,
            thumbColor: Colors.white24,
            groupValue: mode,
            onValueChanged: (BrowserMode? value) {
              if (value != null) onChanged(value);
            },
            children: const <BrowserMode, Widget>{
              BrowserMode.list: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Icon(Icons.view_list, size: 18, color: Colors.white),
              ),
              BrowserMode.card: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Icon(Icons.view_agenda, size: 18, color: Colors.white),
              ),
            },
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
              colors: [Color(0xFF131016), Color(0x00131016)],
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
              colors: [Color(0xFF131016), Color(0x00131016)],
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
    this.selectedIndex,
    this.onTapSpec,
  });
  final List<FontCardSpec> specs;
  final int? selectedIndex;
  final void Function(int index, FontCardSpec spec)? onTapSpec;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      itemCount: specs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 48),
      itemBuilder: (context, index) {
        final FontCardSpec spec = specs[index];
        final bool isDimmed = selectedIndex != null && selectedIndex != index;
        return Opacity(
          opacity: isDimmed ? 0.2 : 1.0,
          child: _FontCard(
            spec: spec,
            onTap: () => onTapSpec?.call(index, spec),
          ),
        );
      },
    );
  }
}

class _FontCardPager extends StatelessWidget {
  const _FontCardPager({
    required this.specs,
    this.selectedIndex,
    this.onTapSpec,
  });
  final List<FontCardSpec> specs;
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
            child: _FontCard(
              spec: specs[index],
              onTap: () => onTapSpec?.call(index, specs[index]),
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showSpecSheet(BuildContext context, FontCardSpec spec) async {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (BuildContext ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xCC131016),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Font details',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    _SpecRow(label: 'Family', value: spec.family),
                    _SpecRow(
                      label: 'Size',
                      value: '${spec.titleSize.toStringAsFixed(0)} px',
                    ),
                    _SpecRow(
                      label: 'Letter spacing',
                      value: '${spec.letterSpacing.toStringAsFixed(2)} px',
                    ),
                    _SpecRow(
                      label: 'Line height',
                      value: '${(spec.lineHeight * 100).toStringAsFixed(0)}%',
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
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
            child: Text(label, style: const TextStyle(color: Colors.white60)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
