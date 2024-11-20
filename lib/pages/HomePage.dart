import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_raspy_led_client/pages/RainbowPage.dart';

import 'package:http/http.dart' as http;

import '../utility/Animation.dart';
import '../utility/Decorations.dart';

class HomePage extends StatefulWidget {
  HomePage({required Key key, required this.title}) : super(key: key);
  final String title;
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<HomePage> {

  static String risposta = "";
  static bool rainbowRunning = false;
  static int rainbowTime = 40;
  static int rainbowBrightness = 255;
  
  double ledBlueValue = 0;
  double ledRedValue = 0;
  double ledGreenValue = 0;
  late int lightValue;

  //final WebSocketChannel channel = IOWebSocketChannel.connect('ws://192.168.1.22:7777');

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonClikAnimation(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 8,
                        decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: [Decorations.shadow()]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                              child: Image(image: AssetImage('assets/rainbow.png'))
                          ),
                        ),
                      ),
                      onTap:() {

                        AnimationTransaction animation = new AnimationTransaction(context: context);
                        RainbowPage screen = new RainbowPage(context:context, notifyParent: refresh);

                        animation.slideUpAnimation(
                            screen.show(),
                            MediaQuery.of(context).size.height,
                            MediaQuery.of(context).size.width / 4,
                            MediaQuery.of(context).size.height / (4/3)
                        );
                        //rainbow(50);
                      },
                    ),
                    ButtonClikAnimation(
                      onTap: () 
                      {
                        setLight();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 8,
                        decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: [Decorations.shadow()]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                              child: Image(image: AssetImage('assets/lightbulb.png'))
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Slider(
                  value: ledBlueValue,
                  min: 0,
                  max: 255,
                  activeColor: Colors.blue,
                  label: ledBlueValue.toInt().toString(),
                  onChanged: (double value) {
                    setState(() {
                      setBlueLED(value.toInt());
                      ledBlueValue = value;
                    });
                  }),
              Slider(
                  value: ledRedValue,
                  min: 0,
                  max: 255,
                  activeColor: Colors.red,
                  label: ledRedValue.toInt().toString(),
                  onChanged: (double value) {
                    setState(() {
                      setRedLED(value.toInt());
                      ledRedValue = value;
                    });
                  }),
              Slider(
                  value: ledGreenValue,
                  min: 0,
                  max: 256,
                  activeColor: Colors.green,
                  label: ledGreenValue.toInt().toString(),
                  onChanged: (double value) {
                    setState(() {
                      setGreenLED(value.toInt());
                      ledGreenValue = value;
                    });
                  }),
              Text(risposta),
              //ButtonClikAnimation(child: null,)
        ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getStatus() async {
    final url = Uri.http("192.168.1.22:7777", "/getLedStatus");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        risposta = response.body;
        Map<String, dynamic> user = jsonDecode(risposta);
        print(user);
        print("rainbow: "+user["rainbowStatus"].toString());
        
        ledRedValue = user["red"].toDouble();
        ledGreenValue = user["green"].toDouble();
        ledBlueValue = user["blue"].toDouble();
        lightValue = user["light"];
        rainbowRunning = user["rainbowStatus"]["rainbowRunning"];
        rainbowBrightness = user["rainbowStatus"]["rainbowBrightness"];
        rainbowTime = user["rainbowStatus"]["time"];
      });
    } else {
      setState(() {
        risposta = "Errore: " + response.body;
      });
      print(risposta);
    }
  }

  setLight() async
  {
    await getStatus();
    int val = lightValue == 0 ? 1 : 0;
    Map<String, String> parameters = {'value': val.toString()};
    final url = Uri.http("192.168.1.22:7777", "/setLight", parameters);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        risposta = response.body;
      });
    } else {
      setState(() {
        risposta = "Errore: " + response.body;
      });
    }

  }

  setRedLED(int val) async {
    Map<String, String> parameters = {'red': val.toString()};
    final url = Uri.http("192.168.1.22:7777", "/setLed", parameters);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        risposta = response.body;
      });
    } else {
      setState(() {
        risposta = "Errore: " + response.body;
      });
    }
  }
  setBlueLED(int val) async {
    Map<String, String> parameters = {'blue': val.toString()};
    final url = Uri.http("192.168.1.22:7777", "/setLed", parameters);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        risposta = response.body;
      });
    } else {
      setState(() {
        risposta = "Errore: " + response.body;
      });
    }
  }
  setGreenLED(int val) async {
    Map<String, String> parameters = {'green': val.toString()};
    final url = Uri.http("192.168.1.22:7777", "/setLed", parameters);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        risposta = response.body;
      });
    } else {
      setState(() {
        risposta = "Errore: " + response.body;
      });
    }
  }

  refresh()
  {
    setState(() {});
  }

}
