import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rc_car/car.dart';

class ControllerPage extends StatefulWidget {
  ControllerPage({super.key, required this.domain}) {
    car = Car(domain: domain);
  }

  final String domain;
  late Car car;
  
  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  String _message = '';
  double _speed = 120;
  double _servo = 400;
  String _image = '';

  void _updateMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  void _updateSpeed(double speed) {
    setState(() {
      _speed = speed;
    });
  }

  void _updateServo(double servo) {
    setState(() {
      _servo = servo;
    });
  }

  void _updateImage(int tick) {
    setState(() {
      _image = '${widget.domain}/cam-lo.jpg?t=$tick';
    });
  }

  @override
  void initState() {
    super.initState();

    var car = widget.car;
    car.onError = (message) => {
      _updateMessage(message)
    };

    // runs every 1 second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateImage(timer.tick);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controller Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              _image,
              errorBuilder: (context, exception, stackTrace) {
                  return Text(exception.toString());
              },
            ),
            ElevatedButton(
              child: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.black,
                size: 36.0,
              ),
              onPressed: () {
                widget.car.go(Direction.up);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black,
                    size: 36.0,
                  ),
                  onPressed: () {
                    widget.car.go(Direction.left);
                  },
                ),
                ElevatedButton(
                  child: const Text('STOP'),
                  onPressed: () {
                    widget.car.stop();
                  },
                ),
                ElevatedButton(
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                    size: 36.0,
                  ),
                  onPressed: () {
                    widget.car.go(Direction.right);
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
                size: 36.0,
              ),
              onPressed: () {
                widget.car.go(Direction.down);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("車速"),
                Slider(
                  max: 255,
                  min: 50,
                  value: _speed, 
                  onChanged: (speed) {
                    _updateSpeed(speed);
                    widget.car.setSpeed(speed.toInt());
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("燈光"),
                ElevatedButton(
                  child: const Text('切換'),
                  onPressed: () {
                    widget.car.toggleLight();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("伺服"),
                Slider(
                  max: 700,
                  min: 300,
                  value: _servo, 
                  onChanged: (servo) {
                    _updateServo(servo);
                    widget.car.setServo(servo.toInt());
                  },
                ),
              ],
            ),
            Text(_message)
          ],
        ),
      ),
    );
  }
}
