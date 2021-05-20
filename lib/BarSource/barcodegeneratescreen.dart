import 'dart:ui';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class BarCodeGenerateScreen extends StatefulWidget {
  @override
  _BarCodeGenerateScreenState createState() => _BarCodeGenerateScreenState();
}

class _BarCodeGenerateScreenState extends State<BarCodeGenerateScreen> {
  String _datainString = "000000";
  String _inputerror;
  final TextEditingController _textEditingController = TextEditingController();
  GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Code Generator',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
            ),
            onPressed: sharecode,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 50,
                left: 20,
                right: 10,
                bottom: 20,
              ),
              child: Container(
                height: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: "Enter a custom Message",
                          errorText: _inputerror,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: TextButton(
                        child: Text(
                          "SUBMIT",
                        ),
                        onPressed: () {
                          setState(() {
                            _datainString = _textEditingController.text;
                            _inputerror = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: BarCodeImage(
                    params: Code128BarCodeParams(
                      _datainString,
                      withText: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sharecode() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var item = await boundary.toImage();
      ByteData byteData = await item.toByteData(
        format: ImageByteFormat.png,
      );
      await Share.file(
        'esys image',
        'qrcode.png',
        byteData.buffer.asUint8List(),
        'image/png',
        text: _datainString,
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
