# automatically generated by the FlatBuffers compiler, do not modify
import flatbuffers
from .Schema_generated import *
from .SparseTensor_generated import *
from .Tensor_generated import *


@value
struct CompressionType(EqualityComparable):
    var value: Int8

    alias LZ4_FRAME = CompressionType(0)
    alias ZSTD = CompressionType(1)

    fn __eq__(self, other: CompressionType) -> Bool:
        return self.value == other.value

    fn __ne__(self, other: CompressionType) -> Bool:
        return self.value != other.value


#  Provided for forward compatibility in case we need to support different
#  strategies for compressing the IPC message body (like whole-body
#  compression rather than buffer-level) in the future
@value
struct BodyCompressionMethod(EqualityComparable):
    var value: Int8

    #  Each constituent buffer is first compressed with the indicated
    #  compressor, and then written with the uncompressed length in the first 8
    #  bytes as a 64-bit little-endian signed integer followed by the compressed
    #  buffer bytes (and then padding as required by the protocol). The
    #  uncompressed length may be set to -1 to indicate that the data that
    #  follows is not compressed, which can be useful for cases where
    #  compression does not yield appreciable savings.
    alias BUFFER = BodyCompressionMethod(0)

    fn __eq__(self, other: BodyCompressionMethod) -> Bool:
        return self.value == other.value

    fn __ne__(self, other: BodyCompressionMethod) -> Bool:
        return self.value != other.value


#  ----------------------------------------------------------------------
#  The root Message type
#  This union enables us to easily send different message types without
#  redundant storage, and in the future we can easily add new message types.
#
#  Arrow implementations do not need to implement all of the message types,
#  which may include experimental metadata types. For maximum compatibility,
#  it is best to send data using RecordBatch
@value
struct MessageHeader(EqualityComparable):
    var value: UInt8

    alias NONE = MessageHeader(0)
    alias Schema = MessageHeader(1)
    alias DictionaryBatch = MessageHeader(2)
    alias RecordBatch = MessageHeader(3)
    alias Tensor = MessageHeader(4)
    alias SparseTensor = MessageHeader(5)

    fn __eq__(self, other: MessageHeader) -> Bool:
        return self.value == other.value

    fn __ne__(self, other: MessageHeader) -> Bool:
        return self.value != other.value


#  ----------------------------------------------------------------------
#  Data structures for describing a table row batch (a collection of
#  equal-length Arrow arrays)
#  Metadata about a field at some level of a nested type tree (but not
#  its children).
#
#  For example, a List<Int16> with values `[[1, 2, 3], null, [4], [5, 6], null]`
#  would have {length: 5, null_count: 2} for its List node, and {length: 6,
#  null_count: 0} for its Int16 node, as separate FieldNode structs
@value
struct FieldNode:
    var _buf: UnsafePointer[UInt8]
    var _pos: Int

    #  The number of value slots in the Arrow array at this level of a nested
    #  tree
    fn length(self) -> Int64:
        return flatbuffers.read[DType.int64](self._buf, int(self._pos) + 0)

    #  The number of observed nulls. Fields with null_count == 0 may choose not
    #  to write their physical validity bitmap out as a materialized buffer,
    #  instead setting the length of the bitmap buffer to 0.
    fn null_count(self) -> Int64:
        return flatbuffers.read[DType.int64](self._buf, int(self._pos) + 8)

    @staticmethod
    fn build(
        inout builder: flatbuffers.Builder,
        *,
        length: Int64,
        null_count: Int64,
    ):
        builder.prep(8, 16)
        builder.prepend[DType.int64](null_count)
        builder.prepend[DType.int64](length)


@value
struct FieldNodeVO:
    var null_count: Int64
    var length: Int64


#  Optional compression for the memory buffers constituting IPC message
#  bodies. Intended for use with RecordBatch but could be used for other
#  message types
@value
struct BodyCompression:
    var _buf: UnsafePointer[UInt8]
    var _pos: Int

    #  Compressor library.
    #  For LZ4_FRAME, each compressed buffer must consist of a single frame.
    fn codec(self) -> CompressionType:
        return flatbuffers.field[DType.int8](self._buf, int(self._pos), 4, 0)

    #  Indicates the way the record batch body was compressed
    fn method(self) -> BodyCompressionMethod:
        return flatbuffers.field[DType.int8](self._buf, int(self._pos), 6, 0)

    @staticmethod
    fn as_root(buf: UnsafePointer[UInt8]) -> BodyCompression:
        return BodyCompression(buf, flatbuffers.read_offset_as_int(buf, 0))

    @staticmethod
    fn build(
        inout builder: flatbuffers.Builder,
        *,
        codec: CompressionType = CompressionType(0),
        method: BodyCompressionMethod = BodyCompressionMethod(0),
    ) -> flatbuffers.Offset:
        builder.start_object(2)
        if codec != CompressionType(0):
            builder.prepend(codec.value)
            builder.slot(0)
        if method != BodyCompressionMethod(0):
            builder.prepend(method.value)
            builder.slot(1)
        return builder.end_object()


#  A data header describing the shared memory layout of a "record" or "row"
#  batch. Some systems call this a "row batch" internally and others a "record
#  batch".
@value
struct RecordBatch:
    var _buf: UnsafePointer[UInt8]
    var _pos: Int

    #  number of records / rows. The arrays in the batch should all have this
    #  length
    fn length(self) -> Int64:
        return flatbuffers.field[DType.int64](self._buf, int(self._pos), 4, 0)

    #  Nodes correspond to the pre-ordered flattened logical schema
    fn nodes(self, i: Int) -> FieldNode:
        var start = flatbuffers.field_vector(
            self._buf, int(self._pos), 6
        ) + i * 16
        return FieldNode(self._buf, start)

    fn has_nodes(self) -> Bool:
        return flatbuffers.has_field(self._buf, int(self._pos), 6)

    fn nodes_length(self) -> Int:
        return flatbuffers.field_vector_len(self._buf, int(self._pos), 6)

    #  Buffers correspond to the pre-ordered flattened buffer tree
    #
    #  The number of buffers appended to this list depends on the schema. For
    #  example, most primitive arrays will have 2 buffers, 1 for the validity
    #  bitmap and 1 for the values. For struct arrays, there will only be a
    #  single buffer for the validity (nulls) bitmap
    fn buffers(self, i: Int) -> Buffer:
        var start = flatbuffers.field_vector(
            self._buf, int(self._pos), 8
        ) + i * 16
        return Buffer(self._buf, start)

    fn has_buffers(self) -> Bool:
        return flatbuffers.has_field(self._buf, int(self._pos), 8)

    fn buffers_length(self) -> Int:
        return flatbuffers.field_vector_len(self._buf, int(self._pos), 8)

    #  Optional compression of the message body
    fn compression(self) -> Optional[BodyCompression]:
        var o = flatbuffers.field_table(self._buf, int(self._pos), 10)
        if o:
            return BodyCompression(self._buf, o.take())
        return None

    #  Some types such as Utf8View are represented using a variable number of buffers.
    #  For each such Field in the pre-ordered flattened logical schema, there will be
    #  an entry in variadicBufferCounts to indicate the number of number of variadic
    #  buffers which belong to that Field in the current RecordBatch.
    #
    #  For example, the schema
    #      col1: Struct<alpha: Int32, beta: BinaryView, gamma: Float64>
    #      col2: Utf8View
    #  contains two Fields with variadic buffers so variadicBufferCounts will have
    #  two entries, the first counting the variadic buffers of `col1.beta` and the
    #  second counting `col2`'s.
    #
    #  This field may be omitted if and only if the schema contains no Fields with
    #  a variable number of buffers, such as BinaryView and Utf8View.
    fn variadicBufferCounts(self, i: Int) -> Int64:
        return flatbuffers.read[DType.int64](
            self._buf,
            flatbuffers.field_vector(self._buf, int(self._pos), 12) + i * 8,
        )

    fn has_variadicBufferCounts(self) -> Bool:
        return flatbuffers.has_field(self._buf, int(self._pos), 12)

    fn variadicBufferCounts_length(self) -> Int:
        return flatbuffers.field_vector_len(self._buf, int(self._pos), 12)

    @staticmethod
    fn as_root(buf: UnsafePointer[UInt8]) -> RecordBatch:
        return RecordBatch(buf, flatbuffers.read_offset_as_int(buf, 0))

    @staticmethod
    fn build(
        inout builder: flatbuffers.Builder,
        *,
        length: Int64 = 0,
        nodes: List[FieldNodeVO] = List[FieldNodeVO](),
        buffers: List[BufferVO] = List[BufferVO](),
        compression: Optional[flatbuffers.Offset] = None,
        variadicBufferCounts: List[Int64] = List[Int64](),
    ) -> flatbuffers.Offset:
        var _nodes: Optional[flatbuffers.Offset] = None
        if len(nodes) > 0:
            builder.start_vector(16, len(nodes), 8)
            for o in nodes.__reversed__():
                FieldNode.build(
                    builder,
                    length=o[].length,
                    null_count=o[].null_count,
                )
            _nodes = builder.end_vector(len(nodes))

        var _buffers: Optional[flatbuffers.Offset] = None
        if len(buffers) > 0:
            builder.start_vector(16, len(buffers), 8)
            for o in buffers.__reversed__():
                Buffer.build(
                    builder,
                    offset=o[].offset,
                    length=o[].length,
                )
            _buffers = builder.end_vector(len(buffers))

        var _variadicBufferCounts: Optional[flatbuffers.Offset] = None
        if len(variadicBufferCounts) > 0:
            builder.start_vector(8, len(variadicBufferCounts), 8)
            for o in variadicBufferCounts.__reversed__():
                builder.prepend(o[])
            _variadicBufferCounts = builder.end_vector(
                len(variadicBufferCounts)
            )

        builder.start_object(5)
        if length != 0:
            builder.prepend(length)
            builder.slot(0)
        if _nodes is not None:
            builder.prepend(_nodes.value())
            builder.slot(1)
        if _buffers is not None:
            builder.prepend(_buffers.value())
            builder.slot(2)
        if compression is not None:
            builder.prepend(compression.value())
            builder.slot(3)
        if _variadicBufferCounts is not None:
            builder.prepend(_variadicBufferCounts.value())
            builder.slot(4)
        return builder.end_object()


#  For sending dictionary encoding information. Any Field can be
#  dictionary-encoded, but in this case none of its children may be
#  dictionary-encoded.
#  There is one vector / column per dictionary, but that vector / column
#  may be spread across multiple dictionary batches by using the isDelta
#  flag
@value
struct DictionaryBatch:
    var _buf: UnsafePointer[UInt8]
    var _pos: Int

    fn id(self) -> Int64:
        return flatbuffers.field[DType.int64](self._buf, int(self._pos), 4, 0)

    fn data(self) -> Optional[RecordBatch]:
        var o = flatbuffers.field_table(self._buf, int(self._pos), 6)
        if o:
            return RecordBatch(self._buf, o.take())
        return None

    #  If isDelta is true the values in the dictionary are to be appended to a
    #  dictionary with the indicated id. If isDelta is false this dictionary
    #  should replace the existing dictionary.
    fn isDelta(self) -> Scalar[DType.bool]:
        return flatbuffers.field[DType.bool](self._buf, int(self._pos), 8, 0)

    @staticmethod
    fn as_root(buf: UnsafePointer[UInt8]) -> DictionaryBatch:
        return DictionaryBatch(buf, flatbuffers.read_offset_as_int(buf, 0))

    @staticmethod
    fn build(
        inout builder: flatbuffers.Builder,
        *,
        id: Int64 = 0,
        data: Optional[flatbuffers.Offset] = None,
        isDelta: Scalar[DType.bool] = 0,
    ) -> flatbuffers.Offset:
        builder.start_object(3)
        if id != 0:
            builder.prepend(id)
            builder.slot(0)
        if data is not None:
            builder.prepend(data.value())
            builder.slot(1)
        if isDelta != 0:
            builder.prepend(isDelta)
            builder.slot(2)
        return builder.end_object()


@value
struct Message:
    var _buf: UnsafePointer[UInt8]
    var _pos: Int

    fn version(self) -> MetadataVersion:
        return flatbuffers.field[DType.int16](self._buf, int(self._pos), 4, 0)

    fn header_type(self) -> MessageHeader:
        return flatbuffers.field[DType.uint8](self._buf, int(self._pos), 6, 0)

    fn header_as_Schema(self) -> Schema:
        return Schema(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 8).or_else(0),
        )

    fn header_as_DictionaryBatch(self) -> DictionaryBatch:
        return DictionaryBatch(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 8).or_else(0),
        )

    fn header_as_RecordBatch(self) -> RecordBatch:
        return RecordBatch(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 8).or_else(0),
        )

    fn header_as_Tensor(self) -> Tensor:
        return Tensor(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 8).or_else(0),
        )

    fn header_as_SparseTensor(self) -> SparseTensor:
        return SparseTensor(
            self._buf,
            flatbuffers.field_table(self._buf, int(self._pos), 8).or_else(0),
        )

    fn bodyLength(self) -> Int64:
        return flatbuffers.field[DType.int64](self._buf, int(self._pos), 10, 0)

    fn custom_metadata(self, i: Int) -> KeyValue:
        var start = flatbuffers.field_vector(
            self._buf, int(self._pos), 12
        ) + i * 4
        start += flatbuffers.read_offset_as_int(self._buf, start)
        return KeyValue(self._buf, start)

    fn has_custom_metadata(self) -> Bool:
        return flatbuffers.has_field(self._buf, int(self._pos), 12)

    fn custom_metadata_length(self) -> Int:
        return flatbuffers.field_vector_len(self._buf, int(self._pos), 12)

    @staticmethod
    fn as_root(buf: UnsafePointer[UInt8]) -> Message:
        return Message(buf, flatbuffers.read_offset_as_int(buf, 0))

    @staticmethod
    fn build(
        inout builder: flatbuffers.Builder,
        *,
        version: MetadataVersion = MetadataVersion(0),
        header_type: MessageHeader = MessageHeader(0),
        header: Optional[flatbuffers.Offset] = None,
        bodyLength: Int64 = 0,
        custom_metadata: List[flatbuffers.Offset] = List[flatbuffers.Offset](),
    ) -> flatbuffers.Offset:
        var _custom_metadata: Optional[flatbuffers.Offset] = None
        if len(custom_metadata) > 0:
            builder.start_vector(4, len(custom_metadata), 4)
            for o in custom_metadata.__reversed__():
                builder.prepend(o[])
            _custom_metadata = builder.end_vector(len(custom_metadata))

        builder.start_object(5)
        if version != MetadataVersion(0):
            builder.prepend(version.value)
            builder.slot(0)
        if header_type != MessageHeader(0):
            builder.prepend(header_type.value)
            builder.slot(1)
        if header is not None:
            builder.prepend(header.value())
            builder.slot(2)
        if bodyLength != 0:
            builder.prepend(bodyLength)
            builder.slot(3)
        if _custom_metadata is not None:
            builder.prepend(_custom_metadata.value())
            builder.slot(4)
        return builder.end_object()
