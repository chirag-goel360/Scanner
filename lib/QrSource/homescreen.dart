import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanner/BarSource/barcodegeneratescreen.dart';
import 'package:scanner/QrSource/generatecodescreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrcode = "";

  @override
  void initState() {
    super.initState();
  }

  Widget _getDrawer(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                'https://miro.medium.com/max/875/1*PnL11kDL6vX52Ki6_U3u1Q.png',
              ),
            ),
          ),
          child: Center(
            child: Container(
              child: Text(
                'Max Scanner',
                style: TextStyle(
                  fontSize: 45.0,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
          ),
        ),
        ListTile(
          title: Text(
            'QR Code Generator',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GenerateQRCode(),
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            'BarCode Generator',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarCodeGenerateScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'QR and Barcode Scanner',
        ),
      ),
      drawer: Drawer(
        child: _getDrawer(context),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: () {
                  scancode();
                },
                child: const Text(
                  'Start Scanning',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                qrcode,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future scancode() async {
    try {
      ScanResult qrcoderes = await BarcodeScanner.scan();
      if (qrcoderes.type == ResultType.Barcode)
        setState(() {
          this.qrcode = qrcoderes.rawContent;
        });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.qrcode =
              'The user not allowed access to camera to the application';
        });
      } else {
        setState(() {
          this.qrcode = 'Unknown error';
        });
      }
    } on FormatException {
      setState(() {
        this.qrcode = 'back button pressed before scanning';
      });
    } catch (e) {
      setState(() {
        this.qrcode = 'Unknown error';
      });
    }
  }
}
