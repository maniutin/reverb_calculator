import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reliable_interval_timer/reliable_interval_timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'Reverb & Delay Calculator',
          theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              scaffoldBackgroundColor: Colors.grey),
          home: MyHomePage(title: 'Reverb & Delay Calculator'),
        ));
  }
}

class MyAppState extends ChangeNotifier {
  int _defaultValue = 120;
  late int _currentTempo = _defaultValue;

  void storeTempo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('tempo', _currentTempo);
  }

  void loadTempo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("load shit");
    _currentTempo = prefs.getInt('tempo') ?? 120;
  }

  void changeTempo(value) {
    _currentTempo = value;
    storeTempo();
    notifyListeners();
  }

  void resetTempo() {
    _currentTempo = _defaultValue;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValuesTable(),
            SizedBox(height: 50),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Metronome(),
                // SizedBox(width: 100),
                TempoSelector(),
                TapTempo(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TempoSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    int currentValue = appState._currentTempo;

    return SizedBox(
      child: GestureDetector(
        onDoubleTap: () => appState.resetTempo(),
        child: Column(
          children: <Widget>[
            const Text(
              'Tempo:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            NumberPicker(
              value: currentValue,
              minValue: 20,
              maxValue: 400,
              onChanged: (value) => appState.changeTempo(value),
            ),
          ],
        ),
      ),
    );
  }
}

class ValuesTable extends StatelessWidget {
  String calculateReverbTime(int tempo, String type, double multiplier) {
    switch (type) {
      case 'predelay':
        return (((60000 / tempo) * multiplier) / 64).toStringAsFixed(2);
      case 'decay':
        return (((60000 / tempo) * multiplier) -
                (((60000 / tempo) * multiplier) / 64))
            .toStringAsFixed(2);
      case 'total':
        return ((60000 / tempo) * multiplier).toStringAsFixed(2);
      default:
        return ('Error');
    }
  }

  String calculateDelayTime(int tempo, String type, double multiplier) {
    switch (type) {
      case 'note':
        return (((60000 / tempo) * multiplier)).toStringAsFixed(2);
      case 'dotted':
        return (((60000 / tempo) * multiplier) * 1.5).toStringAsFixed(2);
      case 'triplet':
        return ((60000 / tempo) * multiplier * 0.667).toStringAsFixed(2);
      default:
        return ('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    int currentValue = appState._currentTempo;

    return Column(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: TabBar(
                tabs: [
                  Text(
                    'Reverb',
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    'Delay',
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
              body: TabBarView(
                children: [
                  // Reverb Table
                  DataTable(
                    columnSpacing: 25.0,
                    columns: [
                      DataColumn(
                        label: Text('Size'),
                      ),
                      DataColumn(
                        label: Text('Pre-Delay'),
                      ),
                      DataColumn(
                        label: Text('Decay'),
                      ),
                      DataColumn(
                        label: Text('Total'),
                      ),
                    ],
                    rows: [
                      // 1/16 Note
                      DataRow(cells: [
                        const DataCell(Text('1/16 Note')),
                        DataCell(Text(calculateReverbTime(
                            currentValue, 'predelay', 0.25))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'decay', 0.25))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'total', 0.25))),
                      ]),
                      // 1/8 Note
                      DataRow(cells: [
                        DataCell(Text('1/8 Note')),
                        DataCell(Text(calculateReverbTime(
                            currentValue, 'predelay', 0.5))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'decay', 0.5))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'total', 0.5))),
                      ]),
                      // 1/4 Note
                      DataRow(cells: [
                        DataCell(Text('1/4 Note')),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'predelay', 1))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'decay', 1))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'total', 1))),
                      ]),
                      // 1/2 Note
                      DataRow(cells: [
                        DataCell(Text('1/2 Note')),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'predelay', 2))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'decay', 2))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'total', 2))),
                      ]),
                      // 1 bar
                      DataRow(cells: [
                        DataCell(Text('1 Bar')),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'predelay', 4))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'decay', 4))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'total', 4))),
                      ]),
                      // 2 bars
                      DataRow(cells: [
                        DataCell(Text('2 Bars')),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'predelay', 8))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'decay', 8))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'total', 8))),
                      ]),
                      // 4 bars
                      DataRow(cells: [
                        DataCell(Text('4 Bars')),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'predelay', 16))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'decay', 16))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'total', 16))),
                      ]),
                      // 8 bars
                      DataRow(cells: [
                        DataCell(Text('8 Bars')),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'predelay', 32))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'decay', 32))),
                        DataCell(Text(
                            calculateReverbTime(currentValue, 'total', 32))),
                      ]),
                    ],
                  ),
                  // Delay Table
                  DataTable(
                    columnSpacing: 30.0,
                    columns: [
                      DataColumn(
                        label: Text('Size'),
                      ),
                      DataColumn(
                        label: Text('Note'),
                      ),
                      DataColumn(
                        label: Text('Dotted'),
                      ),
                      DataColumn(
                        label: Text('Tiplet'),
                      ),
                    ],
                    rows: [
                      // 1/16 Note
                      DataRow(cells: [
                        const DataCell(Text('1/16 Note')),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'note', 0.25))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'dotted', 0.25))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'triplet', 0.25))),
                      ]),
                      // 1/8 Note
                      DataRow(cells: [
                        DataCell(Text('1/8 Note')),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'note', 0.5))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'dotted', 0.5))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'triplet', 0.5))),
                      ]),
                      // 1/4 Note
                      DataRow(cells: [
                        DataCell(Text('1/4 Note')),
                        DataCell(
                            Text(calculateDelayTime(currentValue, 'note', 1))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'dotted', 1))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'triplet', 1))),
                      ]),
                      // 1/2 Note
                      DataRow(cells: [
                        DataCell(Text('1/2 Note')),
                        DataCell(
                            Text(calculateDelayTime(currentValue, 'note', 2))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'dotted', 2))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'triplet', 2))),
                      ]),
                      // 1 bar
                      DataRow(cells: [
                        DataCell(Text('1 Bar')),
                        DataCell(
                            Text(calculateDelayTime(currentValue, 'note', 4))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'dotted', 4))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'triplet', 4))),
                      ]),
                      // 2 bars
                      DataRow(cells: [
                        DataCell(Text('2 Bars')),
                        DataCell(
                            Text(calculateDelayTime(currentValue, 'note', 8))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'dotted', 8))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'triplet', 8))),
                      ]),
                      // 4 bars
                      DataRow(cells: [
                        DataCell(Text('4 Bars')),
                        DataCell(
                            Text(calculateDelayTime(currentValue, 'note', 16))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'dotted', 16))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'triplet', 16))),
                      ]),
                      // 8 bars
                      DataRow(cells: [
                        DataCell(Text('8 Bars')),
                        DataCell(
                            Text(calculateDelayTime(currentValue, 'note', 32))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'dotted', 32))),
                        DataCell(Text(
                            calculateDelayTime(currentValue, 'triplet', 32))),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TapTempo extends StatelessWidget {
  final _precision = 5;
  dynamic _bpm = 0;
  final _taps = [];

  void calcBPM() {
    dynamic currentBpm = 0;
    var ticks = [];

    if (_taps.length >= 2) {
      for (var i = 0; i < _taps.length; i++) {
        if (i >= 1) {
          // calc bpm between last two taps
          ticks.add((60 / (_taps[i] ~/ 10 - _taps[i - 1] ~/ 10)) / 100);
        }
      }
    }

    if (_taps.length >= 24) {
      _taps.removeAt(0);
    }

    if (ticks.length >= 2) {
      currentBpm = getAverage(ticks, _precision);

      _bpm = currentBpm;

      showCurrentBPM();
    }
  }

  dynamic getAverage(values, precision) {
    var ticks = values;
    num n = 0;

    for (var i = ticks.length - 1; i >= 0; i--) {
      n += ticks[i];
      if (ticks.length - i >= precision) break;
    }

    return n / _precision;
  }

  int showCurrentBPM() {
    var calculated = (_bpm * 10000).round();
    if (calculated >= 20) {
      return calculated;
    } else {
      return 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SizedBox(
        height: 100,
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                _taps.add(DateTime.now().toUtc().millisecondsSinceEpoch);
                calcBPM();
                appState.changeTempo(showCurrentBPM());
              },
              child: Text('Tap'),
            ),
          ],
        ));
  }
}

class Metronome extends StatefulWidget {
  const Metronome({super.key});
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<MetronomeState>()
      : context.findAncestorStateOfType<MetronomeState>();

  @override
  State<Metronome> createState() => MetronomeState();
}

class MetronomeState extends State<Metronome> {
  double _tempo = 150;

  final minute = 1000 * 60;
  bool soundEnabled = true;
  late ReliableIntervalTimer _timer;
  static AudioPlayer player = AudioPlayer();

  int _calculateTimerInterval(int tempo) {
    double timerInterval = minute / tempo;

    return timerInterval.round();
  }

  void onTimerTick(int elapsedMilliseconds) async {
    if (soundEnabled) {
      player.play(AssetSource('audio/metronome.wav'));
    }
  }

  ReliableIntervalTimer _scheduleTimer([int milliseconds = 10000]) {
    return ReliableIntervalTimer(
      interval: Duration(milliseconds: milliseconds),
      callback: onTimerTick,
    );
  }

  @override
  void initState() {
    super.initState();

    _timer = _scheduleTimer(_calculateTimerInterval(_tempo.round()));

    _timer.start();
  }

  @override
  void dispose() {
    _timer.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    IconData playIcon = Icons.play_arrow;
    IconData stopIcon = Icons.stop;

    return SizedBox(
        height: 100,
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    _timer = _scheduleTimer(
                      _calculateTimerInterval(_tempo.round()),
                    );

                    await _timer.start();
                  },
                  icon: Icon(playIcon),
                  label: Text('Play'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    await _timer.stop();
                  },
                  icon: Icon(stopIcon),
                  label: Text('Stop'),
                )
              ],
            ),
          ],
        ));
  }
}
