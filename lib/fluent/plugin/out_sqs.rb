module Fluent

    require 'aws-sdk'
    require 'objspace'

    class SQSOutput < BufferedOutput

        Fluent::Plugin.register_output('sqs', self)

        include SetTagKeyMixin
        config_set_default :include_tag_key, false

        include SetTimeKeyMixin
        config_set_default :include_time_key, true

        config_param :aws_key_id, :string, :default => nil, :secret => true
        config_param :aws_sec_key, :string, :default => nil, :secret => true
        config_param :queue_name, :string
        config_param :create_queue, :bool, :default => true
        config_param :sqs_endpoint, :string, :default => 'sqs.ap-northeast-1.amazonaws.com'
        config_param :delay_seconds, :integer, :default => 0
        config_param :include_tag, :bool, :default => true
        config_param :tag_property_name, :string, :default => '__tag'
	config_param :max_size, :integer, :default => 256000

        def configure(conf)
            super
        end

        def start
            super

            AWS.config(
                :access_key_id => @aws_key_id,
                :secret_access_key => @aws_sec_key)

            @sqs = AWS::SQS.new(
                :sqs_endpoint => @sqs_endpoint)
            if @create_queue then
                @queue = @sqs.queues.create(@queue_name)
            else
                @queue = @sqs.queues.named(@queue_name)
            end
        end

        def shutdown
            super
        end

        def format(tag, time, record)
            if @include_tag then
                record[@tag_property_name] = tag
            end

            record.to_msgpack
        end

        def write(chunk)
            records = []
            chunk.msgpack_each {|record|
                if ObjectSpace.memsize_of(record) < @max_size
                    records << { :message_body => Yajl.dump(record), :delay_seconds => @delay_seconds }
                else
                    log.info "Could not send log to SQS: the size of log exceeded max_size"
                end
            }
            until records.length <= 0 do
                @queue.batch_send(records.slice!(0..9))
            end
        end
    end
end
