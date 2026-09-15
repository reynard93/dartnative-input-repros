import 'package:dartnative/dartnative.dart';

import 'dartnative_plugin_registrant.dart';

void main() {
  DartNativePluginRegistrant.registerAll();
  runApp(const KeyboardRepro());
}

class KeyboardRepro extends StatelessWidget {
  const KeyboardRepro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(title: const Text('Keyboard lift repro')),
      body: const Center(
        child: Text('Tap the field. The entire yellow bar should stay visible.'),
      ),
      bottomInputBar: Container(
        color: const Color(0xFFFFFF80),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: const Color(0xFFFFFFFF),
              padding: const EdgeInsets.all(12),
              child: const TextField(
                decoration: InputDecoration(hintText: 'Tap to open keyboard'),
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 4,
              ),
            ),
            const SizedBox(height: 12),
            Button(
              title: 'Footer button',
              onPressed: () => print('FOOTER_TAPPED'),
            ),
            const Text('BOTTOM OF INPUT BAR'),
          ],
        ),
      ),
    );
  }
}
