module Fluent

    require 'aws-sdk'

    class SQSOutput < Output

        Fluent::Plugin.register_output('sqs', self)

        include SetTagKeyMixin
        config_set_default :include_tag_key, false

        include SetTimeKeyMixin
        config_set_default :include_time_key, true

        config_param :aws_key_id, :string
        config_param :aws_sec_key, :string
        config_param :queue_name, :string


        def configure(conf)
            super
        end

        def start
            super
            @sqs = AWS::SQS.new(
                :access_key_id => @aws_key_id,
                :secret_access_key => @aws_sec_key )
                @queue = @sqs.queues.create(@queue_name)
        end

        def shutdown
            super
        end

        def emit(tag, es, chain)
            es.each {|time,record|
                record["time"] = Time.at(time).localtime
                msg = @queue.send_message(record.to_json)
                $stderr.puts "sent message: #{msg.id}"
            }
            chain.next
        end

    end
end
