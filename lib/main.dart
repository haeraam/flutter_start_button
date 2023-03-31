import 'dart:async';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    center: false,
    titleBarStyle: TitleBarStyle.hidden,
    size: Size(160, 180),
    maximumSize: Size(160, 152),
    minimumSize: Size(160, 152),
    alwaysOnTop: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await Window.initialize();
  await Window.setBlurViewState(MacOSBlurViewState.active);
  await Window.setEffect(effect: WindowEffect.aero, color: const Color(0xCC222222), dark: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _second = 0;
  bool _isStart = false;
  late Timer _timer;

  _onClickStartButton() {
    setState(() {
      _isStart = !_isStart;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _second += 1;
        });
      });
    });
  }

  _onClickStopButton() {
    setState(() {
      _isStart = !_isStart;
      _timer.cancel();
    });
  }

  _onClickClearButton() {
    setState(() {
      _second = 0;
    });
  }

  String secondsToTime(int sec) {
    String fixed(int num) {
      return num.toString().padLeft(2, '0').substring(0, 2);
    }

    String hh = fixed(sec ~/ (60 * 60));
    String mm = fixed(sec ~/ (60));
    String ss = fixed(sec);

    return '$hh:$mm:$ss';
  }

// ClipRect
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Expanded(child: SizedBox()),
          Container(
            width: 160,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Text(
              secondsToTime(_second),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w200, color: Colors.white.withOpacity(0.85)),
              textAlign: TextAlign.end,
            ),
          ),
          Row(
            children: [
              AnimatedContainer(
                width: _isStart ? 160 : 110,
                curve: _isStart ? Curves.easeOut : Curves.easeIn,
                height: 80,
                duration: const Duration(milliseconds: 400),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isStart ? Colors.orange.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: _isStart
                          ? const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )
                          : const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                            ),
                    ),
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _isStart ? _onClickStopButton : _onClickStartButton,
                  child: Text(_isStart ? 'stop' : 'start'),
                ),
              ),
              AnimatedContainer(
                width: _isStart ? 0 : 50,
                height: 80,
                curve: !_isStart ? Curves.easeOut : Curves.easeIn,
                duration: const Duration(milliseconds: 300),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.3),
                    fixedSize: const Size.fromWidth(50),
                    padding: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                    ),
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _onClickClearButton,
                  child: Text(
                    'clear',
                    style: TextStyle(fontSize: _isStart ? 0 : 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
