module StateEvent
  module Event
    def self.included(klass)
      klass.send(:extend, ClassMethods)
    end
    
    module InstanceMethods
      def default_aasm_event
        self
      end
      def aasm_prefix= override
        @aasm_prefix = override
      end
      def aasm_prefix
        @aasm_prefix || subject.default_aasm_prefix
      end
    end
 
    module ClassMethods
      def acts_as_state_event(opts={})
        unless ::StateEvent::Config.event_class
          # if not set
          ::StateEvent::Config.event_class = self
        end
        
        include InstanceMethods
      end
      
      def has_event_default(property,  method = nil, &block)
        default_method = "set_event_default_for_#{property}"
        proc = block || Proc.new { |e| e.send(method) }
        define_method default_method do
          return true if send("#{property}")
          if proc.arity == 1
            val = proc.call(self)
          else
            val = proc.call
          end
          send("#{property}=", val)
          true
        end
        before_save default_method
      end
    end
  end
end
