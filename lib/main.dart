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
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color.fromARGB(255, 156, 137, 184),
                secondary: Color.fromARGB(255, 156, 137, 184),
              ),
              scaffoldBackgroundColor: Color.fromARGB(255, 223, 202, 221)),
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
            SizedBox(height: 50),
            ValuesTable(),
            SizedBox(height: 75),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Metronome(),
                SizedBox(width: 100),
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
        child: Center(
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
          ),
        ));
  }
}
