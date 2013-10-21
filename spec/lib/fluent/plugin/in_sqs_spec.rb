require 'spec_helper'

describe do
  let(:driver) {
    AWS.stub!
    Fluent::Test::InputTestDriver.new(Fluent::SQSInput).configure(config)
  }
  let(:instance) {driver.instance}

  describe 'config' do
    let(:config) {
      %[
         aws_key_id AWS_KEY_ID
         aws_sec_key AWS_SEC_KEY
         tag     TAG
         sqs_url SQS_URL
      ]
    }
    
    context do
      subject {instance.aws_key_id}
      it{should == 'AWS_KEY_ID'}
    end

    context do
      subject {instance.aws_sec_key}
      it{should == 'AWS_SEC_KEY'}
    end

    context do
      subject {instance.tag}
      it{should == 'TAG'}
    end

    context do
      subject {instance.sqs_url}
      it{should == 'SQS_URL'}
    end

    context do
      subject {instance.receive_interval}
      it{should == 1}
    end
  end
  
  describe 'emit' do
    let(:message) do
      { :body => 'body',
        :handle => 'handle',
        :id => 'id',
        :md5 => 'md5',
        :url => 'url',
        :sender_id => 'sender_id'
      }
    end
    let(:emmits) {
      stub(Time).now {0}

      class AWS::SQS::Queue
        def receive_message
          yield OpenStruct.new(
            { :body => 'body',
              :handle => 'handle',
              :id => 'id',
              :md5 => 'md5',
              :queue => OpenStruct.new(:url => 'url'),
              :sender_id => 'sender_id',
              :sent_at => 0
            })
        end
      end
      d = driver
      d.run do
        sleep 2
      end
      
      d.emits
    }

    context do
      let(:config) {
        %[
           aws_key_id AWS_KEY_ID
           aws_sec_key AWS_SEC_KEY
           tag     TAG
           sqs_url SQS_URL
        ]
      }

      subject {emmits.first}
      it{should ==  ['TAG', 0, message]}
    end

  end

end