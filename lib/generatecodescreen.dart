import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';

class GenerateCode extends StatefulWidget {
  @override
  _GenerateCodeState createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {
  String datainString = "Hi from this QR Code Scanner";
  String inputerror;
  final TextEditingController _textEditingController = TextEditingController();
  GlobalKey globalKey = new GlobalKey();

  Future<void> sharecode() async{
    try{
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var item = await boundary.toImage();
      ByteData byteData = await item.toByteData(format: ImageByteFormat.png);
      Uint8List Bytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(Bytes);
      final channel = MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile','image.png');
    }
    catch(e){
      print(e.toString());
    }
  }

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
                          errorText: inputerror,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: FlatButton(
                        onPressed: (){
                          setState(() {
                            datainString = _textEditingController.text;
                            inputerror = null;
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
                    data: datainString,
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
}

