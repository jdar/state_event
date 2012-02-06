module StateEvent
  module Config
    extend self

    def event_class=val
      @event_class_string = val.to_s
    end
    
    def event_class
      @event_class_string.constantize
    end
  end
end

