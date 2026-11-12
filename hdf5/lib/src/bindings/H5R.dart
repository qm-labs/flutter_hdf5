import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:hdf5/src/bindings/H5.dart';
import 'package:hdf5/src/bindings/H5O.dart';

import 'package:hdf5/src/c_to_dart_calls/utility.dart';
import 'package:hdf5/src/utility/enum_utils.dart';
import 'package:hdf5/src/utility/logging.dart';

enum H5R_type_t implements IndexEnum<H5R_type_t> {
  BADTYPE(-1, "BadType"),
  OBJECT(0, "Object"),
  DATASET_REGION(1, "Dataset Region"),
  MAXTYPE(2, "MaxType");

  final int value;
  final String string;
  const H5R_type_t(this.value, this.string);

  @override
  toString() => string;

  static H5R_type_t fromIdx(int value) =>
      IndexEnum.fromIdx(H5R_type_t.values, value);
}

typedef H5Rdereference_c = Int64 Function(
    Int64 dataset, Int64 oapl_id, Int32 ref_type, Pointer ref);
typedef H5Rdereference = int Function(
    int dataset, int oapl_id, int ref_type, Pointer ref);

typedef H5Rget_name_c = Int64 Function(
    Int64 loc_id, Int32 ref_type, Pointer ref, Pointer<Uint8> name, Int64 size);
typedef H5Rget_name = int Function(
    int loc_id, int ref_type, Pointer ref, Pointer<Uint8> name, int size);
typedef H5Rget_obj_type_c = Int64 Function(
    Int64 id, Int32 ref_type, Pointer ref, Pointer<Int32> obj_type);
typedef H5Rget_obj_type = int Function(
    int id, int ref_type, Pointer ref, Pointer<Int32> obj_type);

class H5RBindings {
  final H5Rdereference __deReference;
  final H5Rget_name __getName;
  final H5Rget_obj_type __getObjType;

  H5RBindings(DynamicLibrary HDF5Lib)
      : __deReference =
            HDF5Lib.lookup<NativeFunction<H5Rdereference_c>>('H5Rdereference2')
                .asFunction(),
        __getName = HDF5Lib.lookup<NativeFunction<H5Rget_name_c>>('H5Rget_name')
            .asFunction(),
        __getObjType = HDF5Lib.lookup<NativeFunction<H5Rget_obj_type_c>>(
                'H5Rget_obj_type2')
            .asFunction();

  int deReference(int obj_id, Pointer ref) {
    // how to be sure of the H5R_type_t? (should be H5R_OBJECT in most cases)
    // note that there is also an error in the docs, oapl_id not mentioned (observable in the source code).
    final object_id = __deReference(obj_id, H5P_DEFAULT, H5R_type_t.OBJECT.value, ref);
    if (object_id < 0) {
      logger.severe('Failed to dereference reference');
      throw Exception('Failed to dereference');
    }
    return object_id;
  }

  String getName(int obj_id, Pointer ref) {
    final nameSize = __getName(obj_id, H5R_type_t.OBJECT.value, ref, nullptr, 0);
    if (nameSize < 0) {
      logger.severe('Failed to get name of reference (size)');
      throw Exception('Failed to get name');
    }

    Pointer<Uint8> name = calloc<Uint8>(nameSize + 1);
    final status = __getName(obj_id, H5R_type_t.OBJECT.value, ref, name, nameSize + 1);
    if (status < 0) {
      calloc.free(name);
      logger.severe('Failed to get name of reference');
      throw Exception('Failed to get name');
    }

    final result = charToName(name);
    calloc.free(name);
    return result;
  }

  H5O_type_t getObjType(int obj_id, Pointer ref) {
    final Pointer<Int32> objType = calloc<Int32>(1);
    final status = __getObjType(obj_id, H5R_type_t.OBJECT.value, ref, objType);
    if (status < 0) {
      calloc.free(objType);
      logger.severe('Failed to get object type of reference');
      throw Exception('Failed to get object type');
    }

    final result = H5O_type_t.fromIdx(objType.value);
    calloc.free(objType);
    return result;
  }
}
