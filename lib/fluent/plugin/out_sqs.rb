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
        config_param :queue_instance_key, :string


        def configure(conf)
            super
        end

        def start
            super
            @sqs = AWS::SQS.new(
                :access_key_id => @aws_key_id,
                :secret_access_key => @aws_sec_key )
            @queue = @sqs.queues.create(@queue_instance_key)
        end

        def shutdown
            super
        end

        def emit(tag, es, chain)
            chain.next
            es.each {|record|
                msg = @queue.send_message(record)
                $stderr.puts "sent message: #{msg.id}"
            }
        end

    end
end
