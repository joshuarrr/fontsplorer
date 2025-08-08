import 'package:flutter/material.dart';

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
    family: 'Starfox',
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
        body: _mode == BrowserMode.list
            ? _FontListView(specs: kSpecs)
            : _FontCardPager(specs: kSpecs),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
          child: _ModeToggle(
            mode: _mode,
            onChanged: (BrowserMode m) => setState(() => _mode = m),
          ),
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});
  final BrowserMode mode;
  final ValueChanged<BrowserMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ToggleButton(
          icon: Icons.view_list,
          active: mode == BrowserMode.list,
          onTap: () => onChanged(BrowserMode.list),
        ),
        const SizedBox(width: 12),
        _ToggleButton(
          icon: Icons.view_agenda,
          active: mode == BrowserMode.card,
          onTap: () => onChanged(BrowserMode.card),
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24, width: 1.5),
          color: active ? Colors.white12 : Colors.transparent,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _FontCard extends StatelessWidget {
  const _FontCard({required this.spec});
  final FontCardSpec spec;

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(spec.title, textAlign: TextAlign.center, style: _titleStyle()),
        const SizedBox(height: 24),
        Text(spec.artist, textAlign: TextAlign.center, style: _artistStyle()),
      ],
    );
  }
}

class _FontListView extends StatelessWidget {
  const _FontListView({required this.specs});
  final List<FontCardSpec> specs;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      itemCount: specs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 48),
      itemBuilder: (context, index) {
        return _FontCard(spec: specs[index]);
      },
    );
  }
}

class _FontCardPager extends StatelessWidget {
  const _FontCardPager({required this.specs});
  final List<FontCardSpec> specs;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: specs.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _FontCard(spec: specs[index]),
        );
      },
    );
  }
}
