import 'dart:async';

import 'package:dartnative/dartnative.dart';
import 'package:dartnative_skia/dartnative_skia.dart';

import 'dartnative_plugin_registrant.dart';

void main() {
  DartNativePluginRegistrant.registerAll();
  registerSkiaFactories();
  runApp(const ReproMenu());
}

class ReproMenu extends StatelessWidget {
  const ReproMenu({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(title: const Text('Canvas frame repro')),
    body: Center(
      child: Button(
        title: 'Open animated canvas',
        onPressed: () {
          print('[canvas-repro] button callback entered');
          Navigator.of(context).pushReplacement<void, void>(
            PageRoute<void>(builder: (_) => const CanvasProbe()),
          );
        },
      ),
    ),
  );
}

class CanvasProbe extends StatefulWidget {
  const CanvasProbe({super.key});

  @override
  State<CanvasProbe> createState() => _CanvasProbeState();
}

class _CanvasProbeState extends State<CanvasProbe> {
  final painter = ProbePainter();
  late final Ticker ticker;
  late final Timer report;
  int ticks = 0;

  bool ready = false;
  @override
  void initState() {
    super.initState();
    print('[canvas-repro] canvas screen mounted');
    ticker = Ticker((_) => ticks++)..start();
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      print('[canvas-repro] assets ready; enabling animation');
      setState(() => ready = true);
    });
    report = Timer.periodic(const Duration(seconds: 2), (_) {
      print('[canvas-repro] ticker=$ticks paints=${painter.paints}');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF205564),
    appBar: AppBar(title: const Text('Expected: moving white dot')),
    body: Center(
      child: CanvasSurface(
        width: 300,
        height: 400,
        painter: painter,
        animating: ready,
      ),
    ),
  );

  @override
  void dispose() {
    ticker.dispose();
    report.cancel();
    super.dispose();
  }
}

class ProbePainter extends CustomPainter {
  int paints = 0;

  @override
  void paint(Canvas canvas, Size size) {
    paints++;
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.green);
    canvas.drawCircle(
      Offset(40 + (paints % 220).toDouble(), 200),
      20,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(ProbePainter oldDelegate) => true;
}
