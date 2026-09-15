import 'package:dartnative/dartnative.dart';

import 'dartnative_plugin_registrant.dart';

void main() {
  DartNativePluginRegistrant.registerAll();
  runApp(const SubmissionReproApp());
}

class SubmissionReproApp extends StatefulWidget {
  const SubmissionReproApp({super.key});

  @override
  State<SubmissionReproApp> createState() => _SubmissionReproAppState();
}

class _SubmissionReproAppState extends State<SubmissionReproApp> {
  final FocusNode _nextFocus = FocusNode();
  final FocusNode _doneFocus = FocusNode();
  int _nextSubmissions = 0;
  int _doneSubmissions = 0;
  int _manualSubmissions = 0;
  String _lastEvent = 'none';
  String _lastValue = '';

  void _record(String event, String value) {
    setState(() {
      _lastEvent = event;
      _lastValue = value;
      if (event == 'next onSubmitted') {
        _nextSubmissions++;
      } else {
        _doneSubmissions++;
      }
    });
    print('[submit-repro] $event value=${value.replaceAll('\n', '\\n')}');
  }

  void _manualSubmit() {
    setState(() {
      _manualSubmissions++;
      _lastEvent = 'manual button';
      _lastValue = '';
    });
    print('[submit-repro] manual button');
  }

  @override
  void dispose() {
    _nextFocus.dispose();
    _doneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TextField submit repro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tap each field, type text, then use its keyboard action.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              key: const Key('next-field'),
              focusNode: _nextFocus,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Next field',
                hintText: 'Keyboard action: Next',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _record('next onSubmitted', value),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('done-field'),
              focusNode: _doneFocus,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Done field',
                hintText: 'Keyboard action: Done',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _record('done onSubmitted', value),
            ),
            const SizedBox(height: 20),
            Button(
              title: 'Manual submit (Dart)',
              variant: ButtonVariant.filled,
              onPressed: _manualSubmit,
            ),
            const SizedBox(height: 20),
            Text('Next onSubmitted count: $_nextSubmissions'),
            Text('Done onSubmitted count: $_doneSubmissions'),
            Text('Manual button count: $_manualSubmissions'),
            Text('Last event: $_lastEvent'),
            Text('Last value: $_lastValue'),
          ],
        ),
      ),
    );
  }
}
