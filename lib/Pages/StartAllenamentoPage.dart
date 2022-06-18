import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Model/Allenamento.dart';
import 'package:healthy_app/Model/AnagraficaUtente.dart';
import 'package:healthy_app/Pages/HomePage.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../Model/Utente.dart';
import '../Utils/Constants.dart';
import 'Widgets/TopAppBar.dart';

class StartAllenamentoPage extends StatefulWidget {
  Allenamento allenamentoSelected = Allenamento("", "");

  StartAllenamentoPage(Allenamento alle, {Key? key}) : super(key: key){
    allenamentoSelected = alle;
  }
  @override
  _StartAllenamentoPage createState() => _StartAllenamentoPage();
}

class _StartAllenamentoPage extends State<StartAllenamentoPage> {
  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) => print('onChange $value'),
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    onStop: () {
      print('onStop');
    },
    onEnded: () {
      print('onEnded');
    },
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
    _stopWatchTimer.fetchStop.listen((value) => print('stop from stream'));
    _stopWatchTimer.fetchEnded.listen((value) => print('ended from stream'));

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }
  @override
  Widget build(BuildContext context) {
  Allenamento all = widget.allenamentoSelected;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.backgroundColor,
      appBar: makeTopAppBar(context, "Allenamento", Constants.controller),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                /// Display stop watch time
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final displayTime =
                    StopWatchTimer.getDisplayTime(value, hours: _isHours);
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                                fontSize: 40,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                /// Display every minute.
                StreamBuilder<int>(
                  stream: _stopWatchTimer.minuteTime,
                  initialData: _stopWatchTimer.minuteTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    print('Listen every minute. $value');
                    return Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    'minute',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    value.toString(),
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    );
                  },
                ),

                /// Display every second.
                StreamBuilder<int>(
                  stream: _stopWatchTimer.secondTime,
                  initialData: _stopWatchTimer.secondTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    print('Listen every second. $value');
                    return Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    'second',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    value.toString(),
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    );
                  },
                ),

                /// Lap time.
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 100,
                    child: StreamBuilder<List<StopWatchRecord>>(
                      stream: _stopWatchTimer.records,
                      initialData: _stopWatchTimer.records.value,
                      builder: (context, snap) {
                        final value = snap.data!;
                        if (value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        Future.delayed(const Duration(milliseconds: 100), () {
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut);
                        });
                        print('Listen records. $value');
                        return ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final data = value[index];
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    '${index + 1} ${data.displayTime}',
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                )
                              ],
                            );
                          },
                          itemCount: value.length,
                        );
                      },
                    ),
                  ),
                ),

                /// Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: RaisedButton(
                        padding: const EdgeInsets.all(4),
                        color: Colors.lightBlue,
                        shape: const StadiumBorder(),
                        onPressed: () async {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                          Constants.controller.startAllenamento(all, Utente("aa", AnagraficaUtente(9, DateTime.now(), "", 0, "_sesso"), "_email"));
                        },
                        child: const Text(
                          'Inizia',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: RaisedButton(
                        padding: const EdgeInsets.all(4),
                        color: Colors.green,
                        shape: const StadiumBorder(),
                        onPressed: () async {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                          Constants.controller.stopAllenamento(all);
                        },
                        child: const Text(
                          'Stop',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: RaisedButton(
                        padding: const EdgeInsets.all(4),
                        color: Colors.red,
                        shape: const StadiumBorder(),
                        onPressed: () async {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0).copyWith(right: 8),
                        child: RaisedButton(
                          padding: const EdgeInsets.all(4),
                          color: Colors.deepPurpleAccent,
                          shape: const StadiumBorder(),
                          onPressed: () async {
                            _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                          },
                          child: const Text(
                            'Lap',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: RaisedButton(
                          padding: const EdgeInsets.all(4),
                          color: Colors.pinkAccent,
                          shape: const StadiumBorder(),
                          onPressed: () async {
                            _stopWatchTimer.setPresetHoursTime(1);
                          },
                          child: const Text(
                            'Set Hours',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: RaisedButton(
                          padding: const EdgeInsets.all(4),
                          color: Colors.pinkAccent,
                          shape: const StadiumBorder(),
                          onPressed: () async {
                            _stopWatchTimer.setPresetMinuteTime(59);
                          },
                          child: const Text(
                            'Set Minute',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: RaisedButton(
                          padding: const EdgeInsets.all(4),
                          color: Colors.pinkAccent,
                          shape: const StadiumBorder(),
                          onPressed: () async {
                            _stopWatchTimer.setPresetSecondTime(10);
                          },
                          child: const Text(
                            'Set Second',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: RaisedButton(
                    padding: const EdgeInsets.all(4),
                    color: Colors.pinkAccent,
                    shape: const StadiumBorder(),
                    onPressed: () async {
                      _stopWatchTimer.setPresetTime(mSec: 3599 * 1000);
                    },
                    child: const Text(
                      'Set PresetTime',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pinkAccent,
                      onPrimary: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      _stopWatchTimer.clearPresetTime();
                    },
                    child: const Text(
                      'Clear PresetTime',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(40)),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        Constants.controller.updateAllenamento(all);
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.createSnackBar(
                                'Allenamento aggiunto correttamente.',
                                Constants.successSnackBar));
                        Constants.redirectTo(context, HomePage());
                      },
                      color: Constants.backgroundColorLoginButton,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: const Text(
                        "Salva e termina allenamento",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Constants.textButtonColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

