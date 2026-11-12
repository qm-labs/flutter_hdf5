import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hdf5/hdf5.dart';
import 'package:hdf5/src/c_to_dart_calls/utility.dart';

// test/non_ascii_names.h5 was written with h5py:
//   g = f.create_group('målinger_Łódź')
//   d = g.create_dataset('spænding_µV', data=[1.0, 2.0, 3.0])
//   d.attrs['enhed_å'] = 'µV'
const fixture = 'test/non_ascii_names.h5';

void main() {
  test('strToChar encodes UTF-8 and charToName decodes it back', () {
    for (final s in ['plain', 'Søegaard', 'Łódź', 'µV', '量子', 'data 🧪']) {
      final ptr = strToChar(s);
      final bytes = utf8.encode(s);
      expect(ptr.asTypedList(bytes.length + 1), [...bytes, 0], reason: s);
      expect(charToName(ptr), s);
      calloc.free(ptr);
    }
  });

  group('non-ASCII file paths', () {
    late Directory tempDir;
    late String userDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('hdf5_non_ascii_');
      userDir = '${tempDir.path}/VilladsHoffSøegaard'; // ø, as in a Windows user folder
      Directory(userDir).createSync();
    });

    tearDown(() => tempDir.deleteSync(recursive: true));

    test('create and reopen a file', () {
      final path = '$userDir/created.hdf5';
      H5File.create(path).close();
      expect(File(path).existsSync(), isTrue);

      final file = H5File.open(path);
      expect(file.fileId, greaterThanOrEqualTo(0));
      file.close();
    });

    test('open an existing file', () {
      final path = '$userDir/rawdata_qdrive.hdf5';
      File(fixture).copySync(path);

      final file = H5File.open(path);
      expect(file.group.groups, ['målinger_Łódź']);
      file.close();
    });
  });

  test('list and open objects with non-ASCII names', () {
    final file = H5File.open(fixture);
    try {
      final root = file.group;
      expect(root.groups, ['målinger_Łódź']);

      final measurements = root['målinger_Łódź'] as H5Group;
      expect(measurements.datasets, ['spænding_µV']);

      final voltage = measurements['spænding_µV'] as H5Dataset;
      expect(voltage.shape, [3]);
      expect(voltage.attr.keys, ['enhed_å']);
      expect(voltage.attr['enhed_å'], 'µV');
    } finally {
      file.close();
    }
  });
}
