require 'spec_helper'

describe do
  let(:driver) do
    Fluent::Test.setup
    Fluent::Test::InputTestDriver.new(Fluent::SQSInput).configure(config)
  end
  let(:instance) { driver.instance }

  describe 'config' do
    let(:config) do
      %(
         aws_key_id AWS_KEY_ID
         aws_sec_key AWS_SEC_KEY
         tag     TAG
         sqs_url http://SQS_URL
         sqs_endpoint http://ENDPOINT_URL
         max_number_of_messages 10
         wait_time_seconds 10
         stub_responses true
      )
    end

    context do
      subject { instance.aws_key_id }
      it { should == 'AWS_KEY_ID' }
    end

    context do
      subject { instance.aws_sec_key }
      it { should == 'AWS_SEC_KEY' }
    end

    context do
      subject { instance.tag }
      it { should == 'TAG' }
    end

    context do
      subject { instance.sqs_url }
      it { should == 'http://SQS_URL' }
    end

    context do
      subject { instance.receive_interval }
      it { should == 0.1 }
    end

    context do
      subject { instance.max_number_of_messages }
      it { should == 10 }
    end

    context do
      subject { instance.wait_time_seconds }
      it { should == 10 }
    end
  end
end
