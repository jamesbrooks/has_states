has_states
=========

Adds one or more state constraints to an ActiveRecord model, as well as providing common state related functionality to that model


Example
=======

If we have a Page model and want to add three states (draft, review and publishes), we can use has_states to add these:

    class Page < ActiveRecord::Base
      has_states :draft, :review, :published
    end
    
This is the equivalent to the following code

    class Page < Activerecord::Base
      STATES = [ :draft, :review, :published]
      
      validates_inclusion_of :states, :in => STATES
      
      named_scope :draft,     :conditions => { :state => 'draft' }
      named_scope :review,    :conditions => { :state => 'review' }
      named_scope :published, :conditions => { :state => 'published' }
      
      def draft?
        state == 'draft'
      end
      
      def review?
        state == 'review'
      end
      
      def published?
        state == 'published'
      end
    end


Detail
======

`has_states` takes a list of states, as well as any additional options (as a hash), for example:

    has_states :there_can_be_only_one
    has_states :first_state, :second_state
    has_states :foo, :bar, :field_name => :awesomeness_state  # the default field_name is :state
    has_states :open, :closed, :prefix => 'door_'  # prefixing is useful if there are multiple states
    
### What the options do ###

1. `field_name`: specifies the field name the state is stored in, by default this is a field called 'state'
2. `prefix`: added a prefix to the named_scopes as well as the boolean accessors (e.g. draft?)

Copyright (c) 2009 James Brooks, released under the MIT license
