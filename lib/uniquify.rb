module Uniquify
  def self.included(base)
    base.extend ClassMethods
  end

  def ensure_unique(name)
    begin
      self[name] = yield
    end while uniquify_exists?(name)
  end

  def uniquify_exists?(name)
    self.class.scoped(:conditions => { name => self[name] }).exists?
  end

  module ClassMethods

    def uniquify(*args, &block)
      options = { :length => 8, :chars => ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a }
      options.merge!(args.pop) if args.last.kind_of? Hash
      args.each do |name|
        before_validation :on => :create  do |record|
          if block
            record.ensure_unique(name, &block)
          else
            record.ensure_unique(name) do
              Array.new(options[:length]) { options[:chars].to_a[rand(options[:chars].to_a.size)] }.join
            end
          end
        end
      end
    end

  end
end

if defined?(ActiveRecord)
  class ActiveRecord::Base
    include Uniquify
  end
end

if defined?(DataMapper)
  module Uniquify
    def uniquify_exists?(name)
      not self.class.all(name => self[name]).empty?
    end

    module ClassMethods
      def before_validation options = {}, &block
        self.class_eval do
          before :create do
            block.call(self)
          end
        end
      end
    end
  end
end
