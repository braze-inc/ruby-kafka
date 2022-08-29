# frozen_string_literal: true

describe Kafka::Protocol::Record do
  let(:encoded_io) { StringIO.new }
  let(:encoder) { Kafka::Protocol::Encoder.new(encoded_io) }

  it 'does not encode app_group_id headers' do
    record = described_class.new(value: 'test', headers: { app_group_id: 'blueberry' })
    record.encode(encoder)
    expect(encoded_io.string['blueberry']).to be_nil

    decoder = Kafka::Protocol::Decoder.from_string(encoded_io.string)
    decoded_record = Kafka::Protocol::Record.decode(decoder)
    expect(decoded_record.headers).to be_empty
  end

  it 'does encode other headers' do
    record = described_class.new(value: 'test', headers: { fruit: 'raspberry' })
    record.encode(encoder)
    expect(encoded_io.string['raspberry']).to_not be_nil

    decoder = Kafka::Protocol::Decoder.from_string(encoded_io.string)
    decoded_record = Kafka::Protocol::Record.decode(decoder)
    expect(decoded_record.headers).to eq({ "fruit" => "raspberry" })
  end
end
