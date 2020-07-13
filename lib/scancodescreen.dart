import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String qrcode = "";

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scancode,
                child: const Text('Start Scanning'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Text(qrcode,textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    );
  }
  Future scancode() async{
    try{
      ScanResult qrcoderes = await BarcodeScanner.scan();
      if(qrcoderes.type == ResultType.Barcode)
        setState(() {
          this.qrcode = qrcoderes.rawContent;
        });
    }
    on PlatformException catch (e){
      if(e.code == BarcodeScanner.cameraAccessDenied){
        setState(() {
          this.qrcode = 'The user not allowed access to camera to the application';
        });
      }
      else{
        setState(() {
          this.qrcode = 'Unknown error';
        });
      }
    }
    on FormatException{
      setState(() {
        this.qrcode = 'back button pressed before scanning';
      });
    }
    catch(e){
      setState(() {
        this.qrcode = 'Unknown error';
      });
    }
  }
}
