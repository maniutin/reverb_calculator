import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:metronome/metronome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'Reverb & Delay Calculator',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color.fromARGB(255, 29, 53, 87),
                secondary: Color.fromARGB(255, 230, 57, 70),
              ),
              scaffoldBackgroundColor: Color.fromARGB(255, 177, 214, 216)),
          home: MyHomePage(title: 'Reverb & Delay Calculator'),
        ));
  }
}

class MyAppState extends ChangeNotifier {
  int _defaultValue = 120;
  late int _currentTempo = _defaultValue;

  // for use in Local Storage
  // void storeTempo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('tempo', _currentTempo);
  // }

  // void loadTempo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print("load shit");
  //   _currentTempo = prefs.getInt('tempo') ?? 120;
  // }

  void changeTempo(value) {
    _currentTempo = value;
    // storeTempo();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            ValuesTable(),
            SizedBox(height: 75),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MetronomeWidget(),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Reverb',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Delay',
                      style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
              body: TabBarView(
                children: [
                  // Reverb Table
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: 25.0,
                      columns: [
                        DataColumn(
                          label: Text('Size'),
                        ),
                        DataColumn(
                          label: Text('Pre-Delay,\nms'),
                        ),
                        DataColumn(
                          label: Text('Decay\nms'),
                        ),
                        DataColumn(
                          label: Text('Total\nms'),
                        ),
                      ],
                      rows: [
                        // 1/16 Note
                        DataRow(cells: [
                          const DataCell(Text('1/16 Note')),
                          DataCell(Text(calculateReverbTime(
                              currentValue, 'predelay', 0.25))),
                          DataCell(Text(calculateReverbTime(
                              currentValue, 'decay', 0.25))),
                          DataCell(Text(calculateReverbTime(
                              currentValue, 'total', 0.25))),
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
                          DataCell(Text(calculateReverbTime(
                              currentValue, 'predelay', 1))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'decay', 1))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'total', 1))),
                        ]),
                        // 1/2 Note
                        DataRow(cells: [
                          DataCell(Text('1/2 Note')),
                          DataCell(Text(calculateReverbTime(
                              currentValue, 'predelay', 2))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'decay', 2))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'total', 2))),
                        ]),
                        // 1 bar
                        DataRow(cells: [
                          DataCell(Text('1 Bar')),
                          DataCell(Text(calculateReverbTime(
                              currentValue, 'predelay', 4))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'decay', 4))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'total', 4))),
                        ]),
                        // 2 bars
                        DataRow(cells: [
                          DataCell(Text('2 Bars')),
                          DataCell(Text(calculateReverbTime(
                              currentValue, 'predelay', 8))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'decay', 8))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'total', 8))),
                        ]),
                        // 4 bars
                        DataRow(cells: [
                          DataCell(Text('4 Bars')),
                          DataCell(Text(calculateReverbTime(
                              currentValue, 'predelay', 16))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'decay', 16))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'total', 16))),
                        ]),
                        // 8 bars
                        DataRow(cells: [
                          DataCell(Text('8 Bars')),
                          DataCell(Text(calculateReverbTime(
                              currentValue, 'predelay', 32))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'decay', 32))),
                          DataCell(Text(
                              calculateReverbTime(currentValue, 'total', 32))),
                        ]),
                      ],
                    ),
                  ),
                  // Delay Table
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: 30.0,
                      columns: [
                        DataColumn(
                          label: Text('Size'),
                        ),
                        DataColumn(
                          label: Text('Note\nms'),
                        ),
                        DataColumn(
                          label: Text('Dotted\nms'),
                        ),
                        DataColumn(
                          label: Text('Tiplet\nms'),
                        ),
                      ],
                      rows: [
                        // 1/16 Note
                        DataRow(cells: [
                          const DataCell(Text('1/16 Note')),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'note', 0.25))),
                          DataCell(Text(calculateDelayTime(
                              currentValue, 'dotted', 0.25))),
                          DataCell(Text(calculateDelayTime(
                              currentValue, 'triplet', 0.25))),
                        ]),
                        // 1/8 Note
                        DataRow(cells: [
                          DataCell(Text('1/8 Note')),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'note', 0.5))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'dotted', 0.5))),
                          DataCell(Text(calculateDelayTime(
                              currentValue, 'triplet', 0.5))),
                        ]),
                        // 1/4 Note
                        DataRow(cells: [
                          DataCell(Text('1/4 Note')),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'note', 1))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'dotted', 1))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'triplet', 1))),
                        ]),
                        // 1/2 Note
                        DataRow(cells: [
                          DataCell(Text('1/2 Note')),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'note', 2))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'dotted', 2))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'triplet', 2))),
                        ]),
                        // 1 bar
                        DataRow(cells: [
                          DataCell(Text('1 Bar')),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'note', 4))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'dotted', 4))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'triplet', 4))),
                        ]),
                        // 2 bars
                        DataRow(cells: [
                          DataCell(Text('2 Bars')),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'note', 8))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'dotted', 8))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'triplet', 8))),
                        ]),
                        // 4 bars
                        DataRow(cells: [
                          DataCell(Text('4 Bars')),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'note', 16))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'dotted', 16))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'triplet', 16))),
                        ]),
                        // 8 bars
                        DataRow(cells: [
                          DataCell(Text('8 Bars')),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'note', 32))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'dotted', 32))),
                          DataCell(Text(
                              calculateDelayTime(currentValue, 'triplet', 32))),
                        ]),
                      ],
                    ),
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

class MetronomeWidget extends StatefulWidget {
  const MetronomeWidget({super.key});

  @override
  State<MetronomeWidget> createState() => MetronomeWidgetState();
}

class MetronomeWidgetState extends State<MetronomeWidget> {
  final _metronomePlugin = Metronome();
  bool isMetroPlaying = false;

  void _startPlayback(tempo) {
    setState(() {
      isMetroPlaying = true;
    });
    _metronomePlugin.play(tempo);
  }

  void _stopPlayback() {
    setState(() {
      isMetroPlaying = false;
    });
    _metronomePlugin.stop();
  }

  @override
  void initState() {
    super.initState();
    _metronomePlugin.setAudioFile('assets/audio/metronome.wav');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    IconData playIcon = Icons.play_arrow;
    IconData stopIcon = Icons.stop;
    _metronomePlugin.setBPM(appState._currentTempo.toDouble());

    return SizedBox(
        height: 100,
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text(
                  'Metronome',
                  style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    isMetroPlaying
                        ? _stopPlayback()
                        : _startPlayback(appState._currentTempo.toDouble());
                  },
                  child: Icon(
                    isMetroPlaying ? stopIcon : playIcon,
                    color: theme.colorScheme.secondary,
                    size: 36,
                  ),
                  // label: Text(isMetroPlaying ? 'Stop' : 'Play'),
                ),
              ],
            ),
          ],
        ));
  }
}

class TempoSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    int currentValue = appState._currentTempo;

    return SizedBox(
      child: GestureDetector(
        onDoubleTap: () => appState.resetTempo(),
        child: Column(
          children: <Widget>[
            Text(
              'Tempo',
              style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
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
    final theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    return SizedBox(
        height: 100,
        width: 100,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                      backgroundColor: Color(0x17000000),
                    ),
                    onPressed: () {
                      _taps.add(DateTime.now().toUtc().millisecondsSinceEpoch);
                      calcBPM();
                      appState.changeTempo(showCurrentBPM());
                    },
                    child: Text(
                      'Tap',
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
