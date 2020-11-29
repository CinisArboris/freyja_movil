import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() async {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SISTEMA FREYJA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Adicion Actas - Elecciones 2020'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageA; File _imageB;
  final picker = ImagePicker(); var pickedIMG; var pickedIMGpath;

  String azureSuscriptionKey = 'CREDENCIALES';
  String endpoint = 'CREDENCIALES';
  var urlTestPOST = {"url":"CREDENCIALES"};
  String urlAzurePost;
  String urlAzureGetA = 'DEFAULT'; String urlAzureGetB = 'DEFAULT';
  // *********************************************
  Future setImageA() async {
    pickedIMG = await picker.getImage(source: ImageSource.gallery);
    pickedIMGpath = pickedIMG.path;
    setState(() {
      if (pickedIMG != null) {
        _imageA = File(pickedIMGpath);
        print ('Imagen A cargada con exito !.');
      } else {
        print('No image selected.');
      }
    });
  }
  Future setImageB() async {
    pickedIMG = await picker.getImage(source: ImageSource.gallery);
    pickedIMGpath = pickedIMG.path;
    setState(() {
      if (pickedIMG != null) {
        _imageB = File(pickedIMGpath);
        print ('Imagen B cargada con exito !.');
      } else {
        print('No image selected.');
      }
    });
  }
  // ********************************
  Future<Mesa> postActas() async  {
    String resourceOCR = 'vision/v3.1/read/analyze?language=es';//OCR SAVE
    urlAzurePost = endpoint + resourceOCR;
    var headersAzureURL = {
      'Content-Type': 'application/json',
      'Ocp-Apim-Subscription-Key': azureSuscriptionKey
    };
    var headersAzureIMAGEN = {
      'Content-Type': 'application/octet-stream',
      'Ocp-Apim-Subscription-Key': azureSuscriptionKey
    };
    var raw;var bodyAzureIMAGEN;http.Response responsePOST;

    raw = _imageA.readAsBytesSync();
    bodyAzureIMAGEN = raw;
    print ('Enviando A .. .. .. .. .. ..');
    responsePOST = await http.post(
      urlAzurePost,
      headers: headersAzureIMAGEN,
      body: bodyAzureIMAGEN);
    urlAzureGetA = responsePOST.headers['operation-location'];
    //urlAzureGetA = 'CREDENCIALES';
    print ('Codigo Operativo: ' + urlAzureGetA.toString());
    print ('Enviando A .. .. .. .. .. ok');


    raw = _imageB.readAsBytesSync();
    bodyAzureIMAGEN = raw;
    print ('Enviando B .. .. .. .. .. ..');
    responsePOST = await http.post(
      urlAzurePost,
      headers: headersAzureIMAGEN,
      body: bodyAzureIMAGEN);
    urlAzureGetB = responsePOST.headers['operation-location'];
    //urlAzureGetB = 'CREDENCIALES';
    print ('Codigo Operativo: ' + urlAzureGetB.toString());
    print ('Enviando B .. .. .. .. .. ok');
  }
  // ********************************
  Future<Mesa> getActas() async {
    print ('<<< DatoA recibido papu');
    print (urlAzureGetA);
    print ('<<< DatoB recibido papu');
    print (urlAzureGetB);
    var headerOPazure = {
      'Ocp-Apim-Subscription-Key': azureSuscriptionKey
    };
    http.Response responseGET;
    var datoTMP; var voto;

    print ('**************************');
    print ('DATOS :: A :: ..');
    responseGET = await http.get(
      urlAzureGetA,
      headers: headerOPazure
    );
    print (responseGET.statusCode);
    print (responseGET.contentLength);
    datoTMP = jsonDecode(responseGET.body);
    datoTMP = datoTMP['analyzeResult']['readResults'][0]['lines'][0]['text'];
    print ('datoTMP:'+datoTMP.toString());
    voto = datoTMP.toString();
    print ('DATOS :: A :: ok');

    print ('**************************');
    print ('DATOS :: B :: ..');
    responseGET = await http.get(
      urlAzureGetB,
      headers: headerOPazure
    );
    print (responseGET.statusCode);
    print (responseGET.contentLength);
    //printWrapped (responseGET.body);
    datoTMP = 0;
    datoTMP = jsonDecode(responseGET.body);
    print ('-------------------------');
    List<String> pilaTMP = [];
    var datoTMP0 = datoTMP['analyzeResult']['readResults'][0]['lines'][0]['text'];
    sleep(const Duration(seconds: 1));
    datoTMP0 = datoTMP0.replaceAll(new RegExp(r'X'), '');
    datoTMP0 = datoTMP0.replaceAll(new RegExp(r' '), '');
    datoTMP0 = datoTMP0.replaceAll(new RegExp(r'x'), '');
    if (datoTMP0 == '') datoTMP0 = 0;
    pilaTMP.add(datoTMP0.toString());
    print (datoTMP0);
    
    var datoTMP1 = datoTMP['analyzeResult']['readResults'][0]['lines'][1]['text'];
    sleep(const Duration(seconds: 1));
    datoTMP1 = datoTMP1.replaceAll(new RegExp(r'X'), '');
    datoTMP1 = datoTMP1.replaceAll(new RegExp(r' '), '');
    datoTMP1 = datoTMP1.replaceAll(new RegExp(r'x'), '');
    if (datoTMP1 == '') datoTMP1 = 0;
    pilaTMP.add(datoTMP1.toString());
    print (datoTMP1);

    var datoTMP2 = datoTMP['analyzeResult']['readResults'][0]['lines'][2]['text'];
    sleep(const Duration(seconds: 1));
    datoTMP2 = datoTMP2.replaceAll(new RegExp(r'X'), '');
    datoTMP2 = datoTMP2.replaceAll(new RegExp(r' '), '');
    datoTMP2 = datoTMP2.replaceAll(new RegExp(r'x'), '');
    if (datoTMP2 == '') datoTMP2 = 0;
    pilaTMP.add(datoTMP2.toString());
    print (datoTMP2);

    var datoTMP3 = datoTMP['analyzeResult']['readResults'][0]['lines'][3]['text'];
    sleep(const Duration(seconds: 1));
    datoTMP3 = datoTMP3.replaceAll(new RegExp(r'X'), '');
    datoTMP3 = datoTMP3.replaceAll(new RegExp(r' '), '');
    datoTMP3 = datoTMP3.replaceAll(new RegExp(r'x'), '');
    if (datoTMP3 == '') datoTMP3 = 0;
    pilaTMP.add(datoTMP3.toString());
    print (datoTMP3);

    var datoTMP4 = datoTMP['analyzeResult']['readResults'][0]['lines'][4]['text'];
    sleep(const Duration(seconds: 1));
    datoTMP4 = datoTMP4.replaceAll(new RegExp(r'X'), '');
    datoTMP4 = datoTMP4.replaceAll(new RegExp(r' '), '');
    datoTMP4 = datoTMP4.replaceAll(new RegExp(r'x'), '');
    if (datoTMP4 == '') datoTMP4 = 0;
    pilaTMP.add(datoTMP4.toString());
    print (datoTMP4);

    var datoTMP5 = datoTMP['analyzeResult']['readResults'][0]['lines'][5]['text'];
    sleep(const Duration(seconds: 1));
    datoTMP5 = datoTMP5.replaceAll(new RegExp(r'X'), '');
    datoTMP5 = datoTMP5.replaceAll(new RegExp(r' '), '');
    datoTMP5 = datoTMP5.replaceAll(new RegExp(r'x'), '');
    if (datoTMP5 == '') datoTMP5 = 0;
    pilaTMP.add(datoTMP5.toString());
    print (datoTMP5);

    var datoTMP6 = datoTMP['analyzeResult']['readResults'][0]['lines'][6]['text'];
    sleep(const Duration(seconds: 1));
    datoTMP6 = datoTMP6.replaceAll(new RegExp(r'X'), '');
    datoTMP6 = datoTMP6.replaceAll(new RegExp(r' '), '');
    datoTMP6 = datoTMP6.replaceAll(new RegExp(r'x'), '');
    if (datoTMP6 == '') datoTMP6 = 0;
    pilaTMP.add(datoTMP6.toString());
    print (datoTMP6);

    //datoTMP = datoTMP['status'];//['readResults'][0]['lines'][0]['text'];
    //print ('datoTMP:'+datoTMP.toString());
    print ('DATOS :: B :: ok');

    print ('**************************');
    print ('Enviando datos a Laravel');
    var headerPostLaravel = {
      'Content-Type'                : 'application/x-www-form-urlencoded',
    };
    

    String urlPostLaravel = 'http://00001111.ddns.net/freyja/public/api/votacion';
    //String urlPostLaravelL = 'http://freyja.test/api/votacion';
    var bodyPostLaravel;
    var i = 1;
    print (pilaTMP.toString());
    while (i <= 7) {
      bodyPostLaravel = 'idmesa='+voto+'&idcandidato='+(i).toString()+'&voto='+pilaTMP[i-1].toString();
      var responsePOST = await http.post(
        urlPostLaravel,
        headers: headerPostLaravel,
        body: bodyPostLaravel
      );
      print (bodyPostLaravel);
      sleep(const Duration(seconds: 1));
      i = i + 1;
    }
    print ('#####################');
    print ('###  FIN PROCESO  ###');
    print ('#####################');
  }
  // ********************************
  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
  // ********************************
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.star,color: Colors.red[500]),
              Expanded(child: _imageA == null ? Text('NaN') : Image.file(_imageA)),
              Icon(Icons.star,color: Colors.red[500]),
              Expanded(child: _imageB == null ? Text('NaN') : Image.file(_imageB)),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cargar fotoA
                FloatingActionButton(
                  child: Icon(Icons.code),
                  onPressed: setImageA
                ),
                SizedBox(height:10),
                // Cargar fotoB
                FloatingActionButton(
                  child: Icon(Icons.list),
                  onPressed: setImageB
                ),
                SizedBox(height: 10),
                // Enviar datos a la API - Computer Vision
                FloatingActionButton(
                  child: Icon(Icons.send_and_archive),
                  onPressed: postActas
                ),
                SizedBox(height: 10),
                // Recibir datos a la API - Computer Vision
                FloatingActionButton(
                  child: Icon(Icons.receipt),
                  onPressed: getActas
                ),
                SizedBox(height: 10),
              ]
          ),
      ),
    );
  }
}
// ***********************************************************
class Mesa {
  final int id;
  Mesa({
    this.id
    });

  factory Mesa.fromJson(Map<String, dynamic> json) {
    return Mesa(
      id: json['id']
    );
  }
}
