import 'package:flutter/material.dart';
import 'package:scanner/scancodescreen.dart';
import 'generatecodescreen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR Code Scanner and Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: (){
                  Navigator.push(
                    context,MaterialPageRoute(builder: (context) => ScanScreen()),
                  );
                },
                child: const Text('Scan QR Code'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: (){
                  Navigator.push(
                    context,MaterialPageRoute(builder: (context) => GenerateCode()),
                  );
                },
                child: const Text('Generate QR Code'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
