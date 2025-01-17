from flatbuffers import *
from arrow_schema.File_generated import *
from testing import *


def test_building_and_reading_a_footer():
    var builder = Builder()
    var o_int_type = Int_.build(builder, bitWidth=16, is_signed=True)
    var o_field1 = Field.build(
        builder,
        name=StringRef("int_field1"),
        type_type=Type.Int_,
        type=o_int_type,
    )
    var o_field2 = Field.build(
        builder,
        name=StringRef("int_field2"),
        type_type=Type.Int_,
        type=o_int_type,
    )
    var o_schema = Schema.build(
        builder,
        features=List(Feature.COMPRESSED_BODY, Feature.DICTIONARY_REPLACEMENT),
        fields=List(o_field1, o_field2),
    )

    # builder.start_vector(24, 2, 8)
    # _ = Block.build(builder, offset=120, metaDataLength=10, bodyLength=200)
    # _ = Block.build(builder, offset=20, metaDataLength=10, bodyLength=100)
    # var o_blocks = builder.end_vector(2)

    var o_md1 = KeyValue.build(
        builder, key=StringRef("a"), value=StringRef("12")
    )
    var o_md2 = KeyValue.build(
        builder, key=StringRef("b"), value=StringRef("24")
    )
    var o_md3 = KeyValue.build(
        builder, key=StringRef("c"), value=StringRef("64")
    )

    var o_footer = Footer.build(
        builder,
        schema=o_schema,
        recordBatches=List(BlockVO(100, 10, 20), BlockVO(200, 10, 120)),
        custom_metadata=List(o_md1, o_md2, o_md3),
    )

    var result = builder^.finish(o_footer)

    var size = len(result)
    print("Resulting buffer:")
    for i in range(size):
        print(result[i], end=", " if (i % 4) != 3 else "\n")
    print()

    var footer = Footer.as_root(result.unsafe_ptr())
    assert_true(footer.version() == MetadataVersion.V1)
    assert_equal(footer.custom_metadata_length(), 3)
    assert_equal(footer.custom_metadata(0).key(), "a")
    assert_equal(footer.custom_metadata(0).value(), "12")
    assert_equal(footer.custom_metadata(1).key(), "b")
    assert_equal(footer.custom_metadata(1).value(), "24")
    assert_equal(footer.custom_metadata(2).key(), "c")
    assert_equal(footer.custom_metadata(2).value(), "64")

    assert_equal(footer.recordBatches_length(), 2)
    assert_equal(footer.recordBatches(0).offset(), 20)
    assert_equal(footer.recordBatches(0).metaDataLength(), 10)
    assert_equal(footer.recordBatches(0).bodyLength(), 100)
    assert_equal(footer.recordBatches(1).offset(), 120)
    assert_equal(footer.recordBatches(1).metaDataLength(), 10)
    assert_equal(footer.recordBatches(1).bodyLength(), 200)

    var schema = footer.schema().value()
    assert_equal(schema.features_length(), 2)
    assert_true(schema.features(0) == Feature.COMPRESSED_BODY)
    assert_true(schema.features(1) == Feature.DICTIONARY_REPLACEMENT)

    assert_equal(schema.fields_length(), 2)
    assert_equal(schema.fields(0).name(), "int_field1")
    assert_true(schema.fields(0).type_type() == Type.Int_)
    assert_equal(schema.fields(0).type_as_Int().bitWidth(), 16)
    assert_equal(schema.fields(0).type_as_Int().is_signed(), True)

    assert_equal(schema.fields(1).name(), "int_field2")
    assert_true(schema.fields(1).type_type() == Type.Int_)
    assert_equal(schema.fields(1).type_as_Int().bitWidth(), 16)
    assert_equal(schema.fields(1).type_as_Int().is_signed(), True)

    _ = result^
