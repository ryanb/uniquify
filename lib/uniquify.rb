module Uniquify
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def uniquify(*args, &block)
      options = { :length => 8, :chars => ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a }
      options.merge!(args.pop) if args.last.kind_of? Hash
      
      class_inheritable_reader(:uniquify_options)
      write_inheritable_attribute(:uniquify_options, options)
      
      args.each do |name|
        before_validation :on => :create do |record|
          if block
            record.ensure_unique(name, &block)
          else
            record.ensure_unique(name)
          end
        end
      end
    end
        
    def generate_unique
      Array.new(uniquify_options[:length]) { uniquify_options[:chars].to_a[rand(uniquify_options[:chars].to_a.size)] }.join
    end
  end
  
  def ensure_unique(name, &block)
    begin
      self[name] = (block ? block.call : self.class.generate_unique)
    end while self.class.exists?(name => self[name])
    
    self[name]
  end
end

class ActiveRecord::Base
  include Uniquify
end
