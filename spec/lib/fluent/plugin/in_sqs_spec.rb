require 'spec_helper'
require 'fluent/plugin/in_sqs'

describe Fluent::SQSInput do
  let(:driver) do
    Fluent::Test.setup
    Fluent::Test::InputTestDriver.new(Fluent::SQSInput).configure(config)
  end
  subject { driver.instance }

  describe '#configure' do
    let(:config) do
      %(
         aws_key_id AWS_KEY_ID
         aws_sec_key AWS_SEC_KEY
         tag TAG
         region REGION
         sqs_url http://SQS_URL
         receive_interval 1
         max_number_of_messages 10
         wait_time_seconds 10
         visibility_timeout 1
         delete_message true
         stub_responses true
      )
    end

    context 'fluentd input configuration settings' do
      it { expect(subject.aws_key_id).to eq('AWS_KEY_ID') }
      it { expect(subject.aws_sec_key).to eq('AWS_SEC_KEY') }
      it { expect(subject.tag).to eq('TAG') }
      it { expect(subject.region).to eq('REGION') }
      it { expect(subject.sqs_url).to eq('http://SQS_URL') }
      it { expect(subject.receive_interval).to eq(1) }
      it { expect(subject.max_number_of_messages).to eq(10) }
      it { expect(subject.wait_time_seconds).to eq(10) }
      it { expect(subject.visibility_timeout).to eq(1) }
      it { expect(subject.delete_message).to eq(true) }
      it { expect(subject.stub_responses).to eq(true) }
    end

    context 'AWS configuration settings' do
      subject { Aws.config }

      before { driver.instance }

      it { expect(subject[:access_key_id]).to eq('AWS_KEY_ID') }
      it { expect(subject[:secret_access_key]).to eq('AWS_SEC_KEY') }
      it { expect(subject[:region]).to eq('REGION') }
    end
  end

  describe '#run' do
    let(:message_attributes) do
      {
        body: 'body',
        receipt_handle: 'receipt_handle',
        message_id: 'message_id',
        md5_of_body: 'md5_of_body',
        queue_url: 'queue_url',
        attributes: { 'SenderId' => 'sender_id' }
      }
    end
    let(:queue) { double(:queue, receive_messages: true) }
    let(:message) { double(:message, **message_attributes.merge(delete: nil)) }
    let(:messages) { [message] }

    context 'with no delete messages param' do
      let(:config) do
        %(
         tag TAG
         max_number_of_messages 10
         wait_time_seconds 10
         visibility_timeout 1
         delete_message false
      )
      end

      before do
        allow(subject).to receive(:queue) { queue }
      end

      it 'parse through messages and emit it' do
        expect(queue).to receive(:receive_messages)
          .with(max_number_of_messages: 10, wait_time_seconds: 10, visibility_timeout: 1) { messages }
        expect(subject).to receive(:parse_message).with(message) { message_attributes }
        expect(message).not_to receive(:delete)
        expect(subject.router).to receive(:emit).with('TAG', kind_of(Integer), message_attributes)

        subject.run
      end
    end

    context 'with no delete messages param' do
      let(:config) do
        %(
         tag TAG
         max_number_of_messages 10
         wait_time_seconds 10
         visibility_timeout 1
         delete_message true
      )
      end

      before do
        allow(subject).to receive(:queue) { queue }
      end

      it 'parse through messages and emit it' do
        expect(queue).to receive(:receive_messages)
          .with(max_number_of_messages: 10, wait_time_seconds: 10, visibility_timeout: 1) { messages }
        expect(subject).to receive(:parse_message).with(message) { message_attributes }
        expect(message).to receive(:delete)
        expect(subject.router).to receive(:emit).with('TAG', kind_of(Integer), message_attributes)

        subject.run
      end
    end
  end
end
