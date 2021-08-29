import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'dart:io';
import '../../widgets/widgets.dart';
import 'package:ext_storage/ext_storage.dart';

class NotesCard extends StatelessWidget {
  final String _name;
  final String _description;
  final String _imageUrl;
  final String _downloadURL;
  final Color _bgColor;
  final String _date;
  NotesCard(
    this._name,
    this._description,
    this._imageUrl,
    this._downloadURL,
    this._bgColor,
    this._date,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: Image.network(_imageUrl),
          trailing: GestureDetector(
            onTap: () async {
              String path = await ExtStorage.getExternalStoragePublicDirectory(
                  ExtStorage.DIRECTORY_DOWNLOADS);
              //String fullPath = tempDir.path + "/boo2.pdf'";
              String fullPath = "$path/${_description}.pdf";

              var dio = Dio();

              await download2(dio, _downloadURL, fullPath, context);

              showToast(msg: "Sucessfully downloaded the file!");
            },
            child: Icon(LineAwesomeIcons.file_download,
                size: 30, color: Colors.black),
          ),
          title: Text(
            _description,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Posted By:" + _name,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Text(
                "Posted On: $_date",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future download2(Dio dio, String url, String savePath, context) async {
  try {
    Response response = await dio.get(
      url,

      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    print(response.headers);
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    print(e);
  }
}
