module ActiveRecord
  module HasStates
    def self.included(base) 
      base.extend(ClassMethods) 
    end
    
    module ClassMethods
      def has_states(*states)
        # Gather states and associated options
        options = {
          :field_name => 'state',
          :prefix     => ''
        }
        
        options.merge!(states.last.is_a?(Hash) ? states.pop : {})
        states.map!(&:to_s)
        
        if states.empty?
          raise Exception.new("#{class_name} has_states does not define any states, at least one state needs to be defined.")
        end
        
        
        # Add states list
        const_set options[:field_name].pluralize.upcase, states
        
        # Add validation
        class_eval "validates_inclusion_of :#{options[:field_name]}, :in => #{states.inspect}"
        
        states.each do |state|
          # Add named scope
          class_eval "named_scope :#{options[:prefix]}#{state}, :conditions => { :#{options[:field_name]} => '#{state}' }"
          
          # Add boolean accessor
          class_eval "def #{options[:prefix]}#{state}? ; #{options[:field_name]} == '#{state}' ; end"
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::HasStates)
