import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:hdf5/src/bindings/H5.dart';
import 'package:hdf5/src/c_to_dart_calls/utility.dart';
import 'package:hdf5/src/utility/logging.dart';

typedef H5Aopen_c = Int64 Function(
    Int64 obj_id, Pointer<Uint8> attr_name, Int64 aapl_id);
typedef H5Aopen = int Function(
    int obj_id, Pointer<Uint8> attr_name, int aapl_id);

typedef H5Aclose_c = Int64 Function(Int64 attr_id);
typedef H5Aclose = int Function(int attr_id);

// little hack to interpret int type as pointer. This is fine one 64 by systems.
typedef H5AcloseNative = Void Function(Pointer<void> attr_id);

typedef H5Aget_num_attrs_c = Int64 Function(Int64 loc_id);
typedef H5Aget_num_attrs = int Function(int loc_id);

typedef H5Aget_type_c = Int64 Function(Int64 attr_id);
typedef H5Aget_type = int Function(int attr_id);

typedef H5Aget_space_c = Int64 Function(Int64 attr_id);
typedef H5Aget_space = int Function(int attr_id);

typedef H5Aget_name_by_idx_c = Int64 Function(
    Int64 loc_id,
    Pointer<Uint8> obj_name,
    Int32 idx_type,
    Int32 order,
    Uint64 n,
    Pointer<Uint8> name,
    Uint64 size,
    Int64 lapl_id);
typedef H5Aget_name_by_idx = int Function(int loc_id, Pointer<Uint8> obj_name,
    int idx_type, int order, int n, Pointer<Uint8> name, int size, int lapl_id);

typedef H5Aread_c = Int64 Function(Int64 attr_id, Int64 type_id, Pointer buf);
typedef H5Aread = int Function(int attr_id, int type_id, Pointer buf);

class H5ABindings {
  final H5Aopen __open;
  final H5Aclose __close;
  final H5Aget_num_attrs __getNumAttrs;
  final H5Aget_name_by_idx __getNameByIdx;

  final H5Aget_type __getType;
  final H5Aget_space __getSpace;

  final H5Aread __read;

  final Pointer<Uint8> obj_name = strToChar(".");

  H5ABindings(DynamicLibrary HDF5Lib)
      : __open =
            HDF5Lib.lookup<NativeFunction<H5Aopen_c>>('H5Aopen').asFunction(),
        __close =
            HDF5Lib.lookup<NativeFunction<H5Aclose_c>>('H5Aclose').asFunction(),
        __getNumAttrs = HDF5Lib.lookup<NativeFunction<H5Aget_num_attrs_c>>(
                'H5Aget_num_attrs')
            .asFunction(),
        __getNameByIdx = HDF5Lib.lookup<NativeFunction<H5Aget_name_by_idx_c>>(
                "H5Aget_name_by_idx")
            .asFunction(),
        __getType = HDF5Lib.lookup<NativeFunction<H5Aget_type_c>>('H5Aget_type')
            .asFunction(),
        __getSpace =
            HDF5Lib.lookup<NativeFunction<H5Aget_space_c>>('H5Aget_space')
                .asFunction(),
        __read =
            HDF5Lib.lookup<NativeFunction<H5Aread_c>>("H5Aread").asFunction();

  int open(int obj_id, Pointer<Uint8> attr_name, int aapl_id) {
    final id = __open(obj_id, attr_name, aapl_id);
    logger.fine('Opened attribute with the id $id');
    if (id < 0) {
      logger.severe(
          'Failed to open attribute with name ${charToName(attr_name)} at the id $id');
      throw Exception("Failed to open attribute");
    }
    return id;
  }

  int close(int attr_id) {
    final status = __close(attr_id);
    logger.fine('Closed attribute with the id $attr_id');
    if (status < 0) {
      logger.severe(
          'Failed to close attribute with status $status and id $attr_id');
      throw Exception("Failed to close attribute");
    }
    return status;
  }

  int getNumAttrs(int loc_id) {
    final numAttrs = __getNumAttrs(loc_id);
    logger.fine("Number of attributes: $numAttrs");
    if (numAttrs < 0) {
      logger.severe("Failed to get number of attributes");
      throw Exception("Failed to get number of attributes");
    }
    return numAttrs;
  }

  String getNameByIdx(loc_id, attr_idx) {
    int attrSize = __getNameByIdx(loc_id, obj_name, H5_INDEX_NAME, H5_ITER_INC,
        attr_idx, nullptr, 0, H5P_DEFAULT);
    logger
        .fine("Attribute name size: $attrSize for index $attr_idx of $loc_id");
    if (attrSize < 0) {
      logger.severe(
          "Failed to get attribute name size by index for index $attr_idx of $loc_id");
      throw Exception("Failed to get attribute name by index");
    }

    Pointer<Uint8> name = calloc<Uint8>(attrSize + 1);
    final status = __getNameByIdx(loc_id, obj_name, H5_INDEX_NAME, H5_ITER_INC,
        attr_idx, name, attrSize + 1, H5P_DEFAULT);
    logger.fine(
        "Attribute name status: $status for index $attr_idx of $loc_id (name == ${charToName(name)})");
    if (status < 0) {
      logger.severe(
          "Failed to get attribute name by index for index $attr_idx of $loc_id");
      throw Exception("Failed to get attribute name by index");
    }

    final attrName = charToName(name);
    calloc.free(name);
    return attrName;
  }

  int getType(int attr_id) {
    final type = __getType(attr_id);
    if (type == -1) {
      logger.severe(
          "Failed to get attribute type for attribute with id $attr_id");
      throw Exception("Failed to get attribute type");
    }
    return type;
  }

  int getSpace(int attr_id) {
    final space = __getSpace(attr_id);
    if (space < 0) {
      logger.severe(
          "Failed to get attribute space for attribute with id $attr_id");
      throw Exception("Failed to get attribute space");
    }
    return space;
  }

  int read(int attr_id, int type_id, Pointer buffer) {
    final status = __read(attr_id, type_id, buffer);
    if (status < 0) {
      logger.severe(
          'Failed to read attribute with status $status and id $attr_id');
      throw Exception("Failed to read attribute");
    }
    return status;
  }
}
