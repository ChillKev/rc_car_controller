import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rc_car/page/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_iot/wifi_iot.dart';

class SelectModePage extends StatefulWidget {
  const SelectModePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SelectModePage> createState() => _SelectModeState();
}

class _SelectModeState extends State<SelectModePage> {
  static const keyDomain = 'domain';
  String _domain = '';
  final domainController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDomain();
  }

  @override
  void dispose() {
    domainController.dispose();
    super.dispose();
  }

  // Loading saved domain on Start
  Future<void> _loadDomain() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _domain = prefs.getString(keyDomain) ?? '第一次使用';
    });
  }

  void _setDomain() async {
    final newDomain = domainController.text;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(keyDomain, newDomain);
    setState(() {
      _domain = newDomain;
    });
  }

  void _selectWifiMode() {
    _navigateControllPage(_domain);
  }

  void _selectApMode() async {
    if(!await WiFiForIoTPlugin.isEnabled()) {
      await WiFiForIoTPlugin.setEnabled(true, shouldOpenSettings: true);
    }

    await WiFiForIoTPlugin.connect('winmarkAP');
    _navigateControllPage('192.168.100.1');
  }

  void _navigateControllPage(String domain) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ControllerPage(domain: domain))
    );
  }

  void _selectFinish() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the SelectModePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '目前WIFI的網址: http:// $_domain',
            ),
            Row(
              children: [
                const Text(
                  '新的網址 http://',
                ),
                Flexible(
                  child: TextField(
                    controller: domainController,
                  ),
                ),
                ElevatedButton(
                  onPressed: _setDomain,
                  child: const Text('更變網址'),
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _selectWifiMode,
                  child: const Text('WIFI進入操控'),
                ),
                ElevatedButton(
                  onPressed: _selectApMode,
                  child: const Text('AP模式進入操控'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _selectFinish,
              child: const Text('離開'),
            ),
          ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
