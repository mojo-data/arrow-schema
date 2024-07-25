# automatically generated by the FlatBuffers compiler, do not modify
import flatbuffers
from .Schema_generated import *


#  ----------------------------------------------------------------------
#  Data structures for dense tensors
#  Shape data for a single axis in a tensor
@value
struct TensorDim:
    var _buf: UnsafePointer[UInt8]
    var _pos: Int

    #  Length of dimension
    fn size(self) -> Int64:
        return flatbuffers.field[DType.int64](self._buf, int(self._pos), 4, 0)

    #  Name of the dimension, optional
    fn name(self) -> StringRef:
        return flatbuffers.field_string(self._buf, int(self._pos), 6)

    fn has_name(self) -> Bool:
        return flatbuffers.has_field(self._buf, int(self._pos), 6)

    @staticmethod
    fn as_root(buf: UnsafePointer[UInt8]) -> TensorDim:
        return TensorDim(buf, flatbuffers.read_offset_as_int(buf, 0))

    @staticmethod
    fn build(
        inout builder: flatbuffers.Builder,
        *,
        size: Int64 = 0,
        name: Optional[StringRef] = None,
    ) -> flatbuffers.Offset:
        var _name: Optional[flatbuffers.Offset] = None
        if name is not None:
            _name = builder.prepend(name.value())
        builder.start_object(2)
        if size != 0:
            builder.prepend(size)
            builder.slot(0)
        if _name is not None:
            builder.prepend(_name.value())
            builder.slot(1)
        return builder.end_object()


@value
struct Tensor:
    var _buf: UnsafePointer[UInt8]
    var _pos: Int

    fn type_type(self) -> Type:
        return flatbuffers.field[DType.uint8](self._buf, int(self._pos), 4, 0)

    #  The type of data contained in a value cell. Currently only fixed-width
    #  value types are supported, no strings or nested types
    fn type_as_Null(self) -> Null:
        return Null(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Int(self) -> Int_:
        return Int_(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_FloatingPoint(self) -> FloatingPoint:
        return FloatingPoint(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Binary(self) -> Binary:
        return Binary(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Utf8(self) -> Utf8:
        return Utf8(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Bool(self) -> Bool_:
        return Bool_(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Decimal(self) -> Decimal:
        return Decimal(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Date(self) -> Date:
        return Date(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Time(self) -> Time:
        return Time(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Timestamp(self) -> Timestamp:
        return Timestamp(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Interval(self) -> Interval:
        return Interval(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_List(self) -> List_:
        return List_(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Struct_(self) -> Struct_:
        return Struct_(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Union(self) -> Union:
        return Union(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_FixedSizeBinary(self) -> FixedSizeBinary:
        return FixedSizeBinary(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_FixedSizeList(self) -> FixedSizeList:
        return FixedSizeList(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Map(self) -> Map:
        return Map(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Duration(self) -> Duration:
        return Duration(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_LargeBinary(self) -> LargeBinary:
        return LargeBinary(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_LargeUtf8(self) -> LargeUtf8:
        return LargeUtf8(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_LargeList(self) -> LargeList:
        return LargeList(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_RunEndEncoded(self) -> RunEndEncoded:
        return RunEndEncoded(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_BinaryView(self) -> BinaryView:
        return BinaryView(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_Utf8View(self) -> Utf8View:
        return Utf8View(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_ListView(self) -> ListView:
        return ListView(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    fn type_as_LargeListView(self) -> LargeListView:
        return LargeListView(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 6).or_else(0),
        )

    #  The dimensions of the tensor, optionally named
    fn shape(self, i: Int) -> TensorDim:
        var start = flatbuffers.field_vector(
            self._buf, int(self._pos), 8
        ) + i * 4
        start += flatbuffers.read_offset_as_int(self._buf, start)
        return TensorDim(self._buf, start)

    fn shape_length(self) -> Int:
        return flatbuffers.field_vector_len(self._buf, int(self._pos), 8)

    #  Non-negative byte offsets to advance one value cell along each dimension
    #  If omitted, default to row-major order (C-like).
    fn strides(self, i: Int) -> Int64:
        return flatbuffers.read[DType.int64](
            self._buf,
            flatbuffers.field_vector(self._buf, int(self._pos), 10) + i * 8,
        )

    fn has_strides(self) -> Bool:
        return flatbuffers.has_field(self._buf, int(self._pos), 10)

    fn strides_length(self) -> Int:
        return flatbuffers.field_vector_len(self._buf, int(self._pos), 10)

    #  The location and size of the tensor's data
    fn data(self) -> Buffer:
        var o = flatbuffers.field_struct(self._buf, int(self._pos), 12)
        return Buffer(self._buf, o.take())

    @staticmethod
    fn as_root(buf: UnsafePointer[UInt8]) -> Tensor:
        return Tensor(buf, flatbuffers.read_offset_as_int(buf, 0))

    @staticmethod
    fn build(
        inout builder: flatbuffers.Builder,
        *,
        type: flatbuffers.Offset,
        shape: List[flatbuffers.Offset],
        data: BufferVO,
        type_type: Type = Type(0),
        strides: List[Int64] = List[Int64](),
    ) -> flatbuffers.Offset:
        var _shape: Optional[flatbuffers.Offset] = None
        if len(shape) > 0:
            builder.start_vector(4, len(shape), 4)
            for o in shape.__reversed__():
                builder.prepend(o[])
            _shape = builder.end_vector(len(shape))

        var _strides: Optional[flatbuffers.Offset] = None
        if len(strides) > 0:
            builder.start_vector(8, len(strides), 8)
            for o in strides.__reversed__():
                builder.prepend(o[])
            _strides = builder.end_vector(len(strides))

        builder.start_object(5)
        if type_type != Type(0):
            builder.prepend(type_type.value)
            builder.slot(0)
        builder.prepend(type)
        builder.slot(1)
        if _shape is not None:
            builder.prepend(_shape.value())
            builder.slot(2)
        if _strides is not None:
            builder.prepend(_strides.value())
            builder.slot(3)
        Buffer.build(
            builder,
            offset=data.offset,
            length=data.length,
        )
        builder.slot(4)
        return builder.end_object()
