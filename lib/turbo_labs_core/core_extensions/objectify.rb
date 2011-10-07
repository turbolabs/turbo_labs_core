require 'active_record'

raise "Must be using ActiveRecord" unless defined?(ActiveRecord::Base)
module TurboLabsCore
  module Objectify
    module Object
      extend ActiveSupport::Concern

      module InstanceMethods
        def objectify(class_name = nil, key = nil)
          class_name ||= self.class.to_s
          if self.nil?
            return class_name.constantize.new
          end
          return self if (!class_name.blank?) && class_name.to_s.constantize.ancestors.include?(ActiveRecord::Base) && (class_name.to_s == 
self.class.to_s)
          raise "Invalid object type" unless Object.const_defined?(class_name.to_s)
          const = class_name.to_s.classify.constantize
          raise "Invalid class given: #{class_name.to_s}" unless const.ancestors.include?(ActiveRecord::Base)
          if !key.blank? && respond_to?(:to_s) && self.to_s !~ /^\s*\d+\s*$/ && const.column_names.include?(key.to_s)
            const.find(:first, :conditions => { key.to_sym => self.to_s })
          elsif respond_to?(:to_i) && self.to_s =~ /^\s*(\d+)\s*$/
            const.find(:first, :conditions => { :id => $1.to_i })
          else
            raise "Invalid lookup value provided: \"#{self.to_s}\""
          end
        end
        def to_object(*args)
          objectify(*args)
        end
        def as_record_id(*args)
          (self.objectify(*args)[:id].to_i) rescue nil
        end
      end
    end
    module Class
      extend ActiveSupport::Concern
      module InstanceMethods
        def objectify(object, key = nil)
          (object.objectify(self.to_s, key) rescue nil)
        end
      end
    end
  end
end
