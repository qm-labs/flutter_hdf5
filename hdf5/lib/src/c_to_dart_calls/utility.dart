import 'dart:ffi';
import 'dart:typed_data';
import 'dart:convert';

import 'package:ffi/ffi.dart';
import 'package:hdf5/src/bindings/H5T.dart';

/// Returns [string] as a null-terminated UTF-8 C string (free with calloc.free).
///
/// HDF5 expects UTF-8 for file names (on Windows it converts them to UTF-16
/// before opening the file) and for object and attribute names.
Pointer<Uint8> strToChar(String string) {
  final Uint8List bytes = utf8.encode(string);
  final Pointer<Uint8> stringPtr = calloc<Uint8>(bytes.length + 1);
  stringPtr.asTypedList(bytes.length).setAll(0, bytes);
  stringPtr[bytes.length] = 0; // terminate with null.
  return stringPtr;
}

/// Decodes a link, attribute, member or object name returned by HDF5.
///
/// Uses UTF-8, the encoding of [strToChar], so a name read from a file can be
/// passed back to HDF5 to open the object it names.
String charToName(Pointer<Uint8> charstr) {
  return charToStringUTF8(charstr, allowMalformed: true);
}

String charToString(Pointer<Uint8> charstr, {maxLen = -1, H5T_cset_t cset = H5T_cset_t.ASCII}) {
  switch (cset) {
    case H5T_cset_t.ASCII:
      return charToStringASCII(charstr, maxLen: maxLen);
    case H5T_cset_t.UTF8:
      return charToStringUTF8(charstr, maxLen: maxLen);
    default:
      throw Exception("Unsupported character set");
  }
}

String charToStringASCII(Pointer<Uint8> charstr, {maxLen = -1}) {
  int lenStr = 0;
  while (charstr[lenStr] != 0 && (maxLen == -1 || lenStr < maxLen)) {
    lenStr++;
  }

  Uint8List stringList = Uint8List(lenStr);

  for (var i = 0; i < lenStr; i++) {
    stringList[i] = charstr[i];
  }
  return String.fromCharCodes(stringList);
}

String charToStringUTF8(Pointer<Uint8> charstr,
    {maxLen = -1, bool allowMalformed = false}) {
  // this uses utf8 encoding.
  int lenStr = 0;
  List<int> uint8List = [];
  while (charstr[lenStr] != 0 && (maxLen == -1 || lenStr < maxLen)) {
    uint8List.add(charstr[lenStr]);
    lenStr++;
  }
  return utf8.decode(uint8List, allowMalformed: allowMalformed);
}

void strToArray(String string, Array<Uint8> array, int size) {
  if (string.length + 1 > size) {
    throw Exception("String is longer than expected size");
  }

  for (var i = 0; i < string.length; i++) {
    array[i] = string.codeUnitAt(i);
  }
  array[string.length] = 0;

}

Pointer<Int64> IntListToPtrArr(List<int> input) {
  Pointer<Int64> arr = calloc<Int64>(input.length);
  for (var i = 0; i < input.length; i++) {
    arr[i] = input[i];
  }
  return arr;
}