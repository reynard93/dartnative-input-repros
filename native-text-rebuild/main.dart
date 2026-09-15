import 'package:dartnative/dartnative.dart';

import 'dartnative_plugin_registrant.dart';

void main() {
  DartNativePluginRegistrant.registerAll();
  runApp(const TextRebuildRepro());
}

class TextRebuildRepro extends StatefulWidget {
  const TextRebuildRepro({super.key});

  @override
  State<TextRebuildRepro> createState() => _TextRebuildReproState();
}

class _TextRebuildReproState extends State<TextRebuildRepro> {
  bool changed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Native text rebuild repro')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Button(
              title: 'Change inherited style once',
              onPressed: () {
                if (changed) return;
                setState(() => changed = true);
                print('[text-rebuild] style changed once; no timer or animation');
              },
            ),
            const SizedBox(height: 24),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: changed ? 28 : 18,
                color: changed ? Colors.red : Colors.black,
              ),
              child: const Text('Inherited text sample'),
            ),
          ],
        ),
      ),
    );
  }
}
