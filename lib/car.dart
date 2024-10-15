import 'package:http/http.dart' as http;

class Car {
  final String domain;
  Function(String message)? onError;
  LightState _lightState = LightState.off;

  Car({required this.domain});

  void go(Direction dir) {
    _getUrl('$domain/car?value=${dir.value}');
  }

  void stop() {
    go(Direction.stop);
  }

  void setSpeed(int speed) {
    _getUrl('$domain/speed?value=$speed');
  }

  void toggleLight() {
    var newState = LightState.off;
    switch (_lightState) {
      case LightState.off:
        newState = LightState.on;
        break;
      case LightState.on:
        newState = LightState.highlight;
        break;
      case LightState.highlight:
        newState = LightState.off;
        break;
    }
    setLight(newState);
  }

  void setLight(LightState state) {
    _lightState = state;
    _getUrl('$domain/light?sw=${state.enabled ? 'on' : 'off'}&value=${state.value}');
  }

  void setServo(int value) {
    if(_lightState != LightState.off) {
      setLight(LightState.off);
    }
    _getUrl('$domain/servo?turn=on&value=$value');
  }

  void _getUrl(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        onError?.call('Code: ${response.statusCode} Reason: ${response.reasonPhrase} Body: ${response.body}');
      }
    } catch(exception) {
      onError?.call(exception.toString());
    }
  }
}

enum Direction {
  up(value: 1),
  left(value: 2),
  stop(value: 3),
  right(value: 4),
  down(value: 5);

  const Direction({required this.value});

  final int value;
}

enum LightState {
  off(enabled: false, value: 0),
  on(enabled: true, value: 100),
  highlight(enabled: true, value: 150);

  const LightState({required this.enabled, required this.value});

  final bool enabled;
  final int value;
}
