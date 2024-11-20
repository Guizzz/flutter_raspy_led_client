import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:http/http.dart' as http;

import '../utility/Animation.dart';
import '../utility/Decorations.dart';
import 'HomePage.dart';

class RainbowPage {

  BuildContext context;
  final Function() notifyParent;
  RainbowPage({required this.context, required this.notifyParent});

  Widget show() {
    return GestureDetector(
      onTap: (){ },
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width / 2,
        child: Scaffold(
          appBar: null,
          backgroundColor: Colors.transparent,
          body: Stack(
              clipBehavior: Clip.hardEdge, children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0x60FFFFFF),
                  ),
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 2,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX:8, sigmaY:8),
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SleekCircularSlider(
                                appearance: CircularSliderAppearance(
                                  customColors: CustomSliderColors(
                                    dynamicGradient: false,
                                    trackColor: Color(0xFF5C5C5C),
                                    progressBarColor: Colors.blue
                                  )
                                ),
                                min: 10.0,
                                max: 200.0,
                                initialValue: MyHomePageState.rainbowTime.toDouble(),
                                innerWidget: (value){
                                  return Center(child: Text(value.toInt().toString() + " msec"));
                                },
                                onChange: (double value) {
                                  MyHomePageState.rainbowTime=value.toInt();
                                  //print(value);
                                }
                              ),
                              SleekCircularSlider(
                                appearance: CircularSliderAppearance(
                                  customColors: CustomSliderColors(
                                    dynamicGradient: false,
                                    trackColor: Color(0xFF5C5C5C),
                                    progressBarColor: Colors.blue
                                  )
                                ),
                                min: 0.0,
                                max: 255.0,
                                initialValue: MyHomePageState.rainbowBrightness.toDouble(),
                                innerWidget: (value){
                                  return Center(child: Text(value.toInt().toString() + " Brightness"));
                                },
                                onChange: (double value) {
                                  MyHomePageState.rainbowBrightness=value.toInt();
                                  setBrightness(value);
                                  //print(value);
                                }
                              ),
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
                                        child: Text(
                                          !MyHomePageState.rainbowRunning?"Start":"Stop",
                                          style: new TextStyle(color: Colors.black),
                                        )
                                    ),
                                  ),
                                ),
                                onTap: ()
                                  {
                                    if(MyHomePageState.rainbowRunning)
                                    {
                                      endRainbow();
                                      MyHomePageState.rainbowRunning=false;
                                      Navigator.pop(context);
                                      //notifyParent();
                                    }
                                    else
                                    {
                                      rainbow(MyHomePageState.rainbowTime);
                                      MyHomePageState.rainbowRunning=true;
                                      Navigator.pop(context);
                                    }

                                  }
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }

  Future<bool> rainbow(int val) async {
    Map<String, String> parameters = {'time': val.toString()};
    final url = Uri.http("192.168.1.22:7777", "/setRainbow", parameters);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      MyHomePageState.risposta = response.body;
      notifyParent();
      return true;
    } else {
      MyHomePageState.risposta = "Errore: " + response.body;
      notifyParent();
      return false;
    }
  }

  Future<bool> setBrightness(double val) async {
    Map<String, String> parameters = {'brightness': val.toInt().toString()};
    final url = Uri.http("192.168.1.22:7777", "/setRainbowBrightness", parameters);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      MyHomePageState.risposta = response.body;
      notifyParent();
      return true;
    } else {
      MyHomePageState.risposta = "Errore: " + response.body;
      notifyParent();
      return false;
    }
  }

  Future<bool> endRainbow() async {
    final url = Uri.http("192.168.1.22:7777", "/stopRainbow");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      MyHomePageState.risposta = response.body;
      notifyParent();
      return true;
    } else {

      MyHomePageState.risposta = "Errore: " + response.body;
      notifyParent();
      return false;
    }
  }

}
