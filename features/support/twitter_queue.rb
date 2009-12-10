class TwitterQueue
  class << self
    def reset
      @@queue = {}
    end
    
    def queue
      @@queue ||= {}
    end
    
    def add(screen_name, status)
      for_user(screen_name) << status
    end
    
    def for_user(screen_name)
      queue[screen_name] ||= []
    end
  end
end