import 'dart:async';

import 'package:bos_timer/model/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BossDataWidget extends StatefulWidget {
  final BossData bossData;
  final DateTime? killTime;

  const BossDataWidget(
      {Key? key, required this.bossData, required this.killTime})
      : super(key: key);

  @override
  State<BossDataWidget> createState() => _BossDataWidgetState();
}

class _BossDataWidgetState extends State<BossDataWidget> {
  late Timer _timer;
  late Duration _remainingTime;
  late String _respawnTimeText;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateRemainingTime() {
    if (widget.killTime == null) {
      return;
    }
    DateTime respawnTime =
        widget.killTime!.add(Duration(minutes: widget.bossData.resp));
    _remainingTime = respawnTime.difference(DateTime.now());
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _calculateRemainingTime();
        _calcRespawnTime();
      });
    });
  }

  void _calcRespawnTime() {
    int hours = _remainingTime.inHours;
    int minutes = _remainingTime.inMinutes.remainder(60);
    int seconds = _remainingTime.inSeconds.remainder(60);
    _respawnTimeText =
        '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.bossData.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 8),
              Text("ID: ${widget.bossData.id}"),
              Text("Resp: ${widget.bossData.resp}"),
              InkWell(
                child: GestureDetector(
                  onTap: () {
                    _copyToClipboard(
                        context, widget.bossData.coord, widget.bossData.name);
                  },
                  child: Row(
                    children: [
                      Text("Coord: "),
                      Expanded(
                        child: Text(
                          widget.bossData.coord,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text("Respawn Timer: $_respawnTimeText"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implementați acțiunea pentru butonul "Killed"
                    },
                    child: Text("Killed"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implementați acțiunea pentru butonul "Killed as Time"
                      _showTimePickerDialog(context);
                    },
                    child: Text("Killed as Time"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text, String name) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name ($text) copied to clipboard')),
    );
  }

  void _showTimePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Time'),
          content: Text('Here you can choose the time.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
