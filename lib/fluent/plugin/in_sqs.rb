module Fluent
  require 'aws-sdk'

  class SQSInput < Input
    Plugin.register_input('sqs', self)

    define_method('router') { Fluent::Engine } unless method_defined?(:router)

    def initialize
      super
    end

    config_param :aws_key_id, :string, default: nil, secret: true
    config_param :aws_sec_key, :string, default: nil, secret: true
    config_param :tag, :string
    config_param :region, :string, default: 'ap-northeast-1'
    config_param :sqs_url, :string
    config_param :receive_interval, :time, default: 0.1
    config_param :max_number_of_messages, :integer, default: 10
    config_param :wait_time_seconds, :integer, default: 10
    config_param :delete_message, :bool, default: false
    config_param :stub_responses, :bool, default: false

    def configure(conf)
      super
    end

    def start
      super

      Aws.config = {
        access_key_id: @aws_key_id,
        secret_access_key: @aws_sec_key,
        region: @region
      }

      @client = Aws::SQS::Client.new(stub_responses: @stub_responses)
      @queue = Aws::SQS::Resource.new(client: @client).queue(@sqs_url)

      @finished = false
      @thread = Thread.new(&method(:run_periodic))
    end

    def shutdown
      super

      @finished = true
      @thread.join
    end

    def run_periodic
      until @finished
        begin
          sleep @receive_interval
          @queue.receive_messages(
            max_number_of_messages: @max_number_of_messages,
            wait_time_seconds: @wait_time_seconds
          ).each do |message|
            record = {}
            record['body'] = message.body.to_s
            record['receipt_handle'] = message.receipt_handle.to_s
            record['message_id'] = message.message_id.to_s
            record['md5_of_body'] = message.md5_of_body.to_s
            record['queue_url'] = message.queue_url.to_s
            record['sender_id'] = message.attributes['SenderId'].to_s

            message.delete if @delete_message

            router.emit(@tag, Time.now.to_i, record)
          end
        rescue
          $log.error 'failed to emit or receive', error: $ERROR_INFO.to_s, error_class: $ERROR_INFO.class.to_s
          $log.warn_backtrace $ERROR_INFO.backtrace
        end
      end
    end
  end
end
