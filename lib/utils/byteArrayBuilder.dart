import 'dart:typed_data';

import 'package:vivarium_control_unit/models/feedTrigger.dart';

class ByteArrayBuilder {
  int size;
  int checksum;
  int listLength = 3;
  var rawDataList = <int>[];

  ByteArrayBuilder();

  void setSizeOfObject(Map<String, dynamic> objectMap) {
    print('size of object');

    var size = 0;
    for (dynamic value in objectMap.values) {
      print(value.runtimeType);

      if (value is int) {
        size += 4;
      }
      if (value is bool) {
        size += 1;
      }
      if (value is double) {
        size += 4;
      }

      if (value is Iterable) {
        print('iterable');
        size += ((4 + 4) * listLength) ~/ (2 / 1); //Feed and led triggers
      }
    }
    print('Size: $size');
    this.size = size;
    checksum = this.size;
  }

  void addData(dynamic data) {
    if (data is bool) {
      addBool(data);
    }
    if (data is int) {
      addInt(data);
    }

    if (data is double) {
      addDouble(data);
    }
    if (data is List<FeedTrigger>) {
      var size = data.length;
      for (var i = 0; i < listLength; i++) {
        if (i < size) {
          var t = data.elementAt(i);
          //  int epoch = t.time;
          //  final list = new Uint64List.fromList([epoch]);
          // final bytes = new Uint8List.view(list.buffer);
          addInt(t.time);
          addInt(t.type);
        } else {
          addInt(0);
          addInt(0);
        }
      }
    }

//    if (data is List<LedTrigger>){
//
//      int size = data.length;
//      for (int i = 0;i<10;i++){
//        if (i<size){
//          LedTrigger t = data.elementAt(i);
//          addInt(t.time);
//          addInt(t.color);
//        } else {
//          addInt(0);
//          addInt(0);
//        }
//      }
//    }
  }

  ///0x06
  ///0x85
  /// - size in bytes
  /// - data
  /// checksum
  Uint8List getDataList() {
    print('Data list length = ${rawDataList.length}');
    var prefixList = Uint8List.fromList([0x06, 0x85]);
    var sizeList = Uint8List.fromList([size]);
    var dataList = Uint8List.fromList(rawDataList);
    var checkSumList = Uint8List.fromList([checksum]);

    return Uint8List.fromList(prefixList + sizeList + dataList + checkSumList);
  }

  void addInt(int data) {
    final list = Uint64List.fromList([data]);
    final bytes = Uint8List.view(list.buffer);
    for (var i = 0; i < 4; i++) {
      checksum ^= bytes.elementAt(i);
      rawDataList.add(bytes.elementAt(i));
    }
  }

  void addBool(bool data) {
    var b = data ? 1 : 0;
    checksum ^= b;
    rawDataList.add(b);
  }

  void addDouble(double data) {
    var valueFloat = Float32List(1);
    valueFloat[0] = data;
    var listOfBytes = valueFloat.buffer.asUint8List();
    for (var i = 0; i < 4; i++) {
      checksum ^= listOfBytes.elementAt(i);
      rawDataList.add(listOfBytes.elementAt(i));
    }
  }
}
