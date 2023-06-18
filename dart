
//Class Added by HexTech Developers


import 'package:esptouch_smartconfig/esptouch_smartconfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novellamp/controllers/all_controllers.dart';
import 'package:sizer/sizer.dart';

import '../home/homepage.dart';

class ConnectionScreen extends StatefulWidget{
  ConnectionScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ConnectionScreenState();
  }

}

class ConnectionScreenState extends State{

  late Stream<ESPTouchResult>? _stream;
  final Set<ESPTouchResult> _results = Set();

  @override
  void initState() {
    _stream = EsptouchSmartconfig.run(ssid: regCntr.ssid.value.text,
        bssid: regCntr.bssid.value.text, password: regCntr.wifiPassword.value.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ESPTouchResult>(
        stream: _stream,
        builder: (context, AsyncSnapshot<ESPTouchResult> snapshot) {
          if (snapshot.hasError) {
            return connectionUnsuccessful();
          }
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              _results.add(snapshot.data!);
              return connectionHasData(state: 'active');
            case ConnectionState.none:
              return connectionUnsuccessful();
            case ConnectionState.done:
              if (snapshot.hasData) {
                _results.add(snapshot.data!);
                return  Stack(
                  children: [
                connectionHasData(state: 'done'),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ElevatedButton(
                        onPressed: (){Get.offAll(()=>HomePage());},
                        child: Text('Done'),
                      ),
                    )
                  ],
                );
              } else {
                return connectionUnsuccessful();
              }
            case ConnectionState.waiting:
              return connectionHasData(state: 'waiting');
          }
        },
      ),
    );
  }
  
  Widget connectionUnsuccessful(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/connect_wifi_page_off.png"),
              fit: BoxFit.cover
          )
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Get.back();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0)
              ),
              width: 120.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh,
                      color: Colors.black),
                  Padding(padding: EdgeInsets.only(left: 24.0)),
                  Text('Try Again', style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget connectionHasData({required String state}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      decoration: state == 'active' || state == 'done' ?
      BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Config_page_lamp_on_bigger.png"),
              fit: BoxFit.cover
          )
      )
      :BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/connect_wifi_page_off.png"),
              fit: BoxFit.cover
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              state == 'active' || state == 'waiting' || state == 'done'
                  ? Icon(Icons.check_circle,
                  color: Colors.green)
              :SizedBox(
                  height: 2.h,
                  width: 4.w,
                  child: CircularProgressIndicator(
                      color: Colors.black)),
              SizedBox(width: 2.w),
              Text(
                regCntr.texts[0],
                style: TextStyle(
                    color: state != 'active' || state != 'waiting' || state != 'done'
                        ? Colors.green
                        : Colors.black),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              state != 'done'
                  ? SizedBox(
                  height: 2.h,
                  width: 4.w,
                  child: CircularProgressIndicator(
                      color: Colors.black))
                  : Icon(Icons.check_circle,
                  color: Colors.green),
              SizedBox(width: 2.w),
              Text(
                regCntr.texts[1],
                style: TextStyle(
                    color: state != 'done'
                        ? Colors.black
                        : Colors.green),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              state != 'done'
                  ? SizedBox(
                  height: 2.h,
                  width: 4.w,
                  child: CircularProgressIndicator(
                      color: Colors.black))
                  : Icon(Icons.check_circle,
                  color: Colors.green),
              SizedBox(width: 2.w),
              Text(
                regCntr.texts[2],
                style: TextStyle(
                    color: state != 'done'
                        ? Colors.black
                        : Colors.green),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      )
    );
  }
  
}


//Class Added by HexTech Developers


