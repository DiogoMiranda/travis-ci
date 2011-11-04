module Travis
  class Consumer
    class Job
      attr_reader :payload

      def handle(event, payload)
        @payload = payload

        puts "Handling job event #{event.inspect} with payload : #{payload.inspect}"

        case event.to_sym
        when :'job:test:log'
          handle_log_update
        else
          handle_update
        end
      end

      protected

        def job
          @job ||= ::Job.find(payload.id)
        end

        def handle_update
          job.update_attributes(payload.to_hash)
        end

        def handle_log_update
          ::Job::Test.append_log!(payload.id, payload.log)
        end
    end
  end
end
