import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class GenerateCode extends StatefulWidget {
  @override
  _GenerateCodeState createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {
  String _datainString = "Hi from this QR Code Scanner";
  String _inputerror;
  final TextEditingController _textEditingController = TextEditingController();
  GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: sharecode,
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50,left: 20,right: 10,bottom: 20),
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
                      padding: EdgeInsets.only(left: 10),
                      child: FlatButton(
                        child:  Text("SUBMIT"),
                        onPressed: (){
                          setState(() {
                            _datainString = _textEditingController.text;
                            _inputerror = null;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    backgroundColor: Colors.white,
                    data: _datainString,
                    size: 0.5 * (MediaQuery.of(context).size.height-MediaQuery.of(context).viewInsets.bottom),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> sharecode() async{
    try{
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var item = await boundary.toImage();
      ByteData byteData = await item.toByteData(format: ImageByteFormat.png);
      await Share.file(
          'esys image', 'qrcode.png',
          byteData.buffer.asUint8List(),
          'image/png',
          text: 'Generated Qr Code'
      );
    }
    catch(e){
      print(e.toString());
    }
  }
}