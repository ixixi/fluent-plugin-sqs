module Fluent

  require 'aws-sdk-v1'

  class SQSInput < Input
    Plugin.register_input('sqs', self)

    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

    def initialize
      super
    end

    config_param :aws_key_id, :string, :default => nil, :secret => true
    config_param :aws_sec_key, :string, :default => nil, :secret => true
    config_param :tag, :string
    config_param :sqs_endpoint, :string, :default => 'sqs.ap-northeast-1.amazonaws.com'
    config_param :sqs_url, :string
    config_param :receive_interval, :time, :default => 0.1
    config_param :max_number_of_messages, :integer, :default => 10
    config_param :wait_time_seconds, :integer, :default => 10

    def configure(conf)
      super

    end

    def start
      super

      AWS.config(
        :access_key_id => @aws_key_id,
        :secret_access_key => @aws_sec_key
        )

      @queue = AWS::SQS.new(:sqs_endpoint => @sqs_endpoint).queues[@sqs_url]

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
          @queue.receive_message(
            :limit => @max_number_of_messages,
            :wait_time_seconds => @wait_time_seconds
          ) do |message|
            record = {}
            record['body'] = message.body.to_s
            record['handle'] = message.handle.to_s
            record['id'] = message.id.to_s
            record['md5'] = message.md5.to_s
            record['url'] = message.queue.url.to_s
            record['sender_id'] = message.sender_id.to_s

            router.emit(@tag, Time.now.to_i, record)
          end
        rescue
          $log.error "failed to emit or receive", :error => $!.to_s, :error_class => $!.class.to_s
          $log.warn_backtrace $!.backtrace
        end
      end
    end
  end
end
