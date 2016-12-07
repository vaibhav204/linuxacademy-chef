# this is NOT an AUTOGENERATED file

require 'chef/resource'

class Chef
  class Resource

    class UnresolvedSubscribes < self
      # The full key ise given as the name in {Resource#subscribes}
      alias_method :to_s, :name
      alias_method :declared_key, :name
    end

    #
    # Force a delayed notification into this resource's run_context.
    #
    # This should most likely be paired with action :nothing
    #
    # @param arg [Array[Symbol], Symbol] A list of actions (e.g. `:create`)
    #
    def delayed_action(arg)
      arg = Array(arg).map(&:to_sym)
      arg.map do |action|
        validate(
          { action: action },
          { action: { kind_of: Symbol, equal_to: allowed_actions } }
        )
        # the resource effectively sends a delayed notification to itself
        run_context.add_delayed_action(Notification.new(self, action, self))
      end
    end

    def subscribes(action, resources, timing = :delayed)
      resources = [resources].flatten
      resources.each do |resource|
        if resource.is_a?(String)
          resource = UnresolvedSubscribes.new(resource, run_context)
        end
        if resource.run_context.nil?
          resource.run_context = run_context
        end
        resource.notifies(action, self, timing)
      end
      true
    end

    def notifies(action, resource_spec, timing = :delayed)
      # when using old-style resources(:template => "/foo.txt") style, you
      # could end up with multiple resources.
      validate_resource_spec!(resource_spec)

      resources = [ resource_spec ].flatten
      resources.each do |resource|

        case timing.to_s
        when "delayed"
          notifies_delayed(action, resource)
        when "immediate", "immediately"
          notifies_immediately(action, resource)
        when "before"
          notifies_before(action, resource)
        else
          raise ArgumentError,  "invalid timing: #{timing} for notifies(#{action}, #{resources.inspect}, #{timing}) resource #{self} "\
            "Valid timings are: :delayed, :immediate, :immediately, :before"
        end
      end

      true
    end

    #
    # Iterates over all immediate and delayed notifications, calling
    # resolve_resource_reference on each in turn, causing them to
    # resolve lazy/forward references.
    def resolve_notification_references
      run_context.before_notifications(self).each { |n|
        n.resolve_resource_reference(run_context.resource_collection)
      }
      run_context.immediate_notifications(self).each { |n|
        n.resolve_resource_reference(run_context.resource_collection)
      }
      run_context.delayed_notifications(self).each {|n|
        n.resolve_resource_reference(run_context.resource_collection)
      }
    end

    # Helper for #notifies
    def notifies_before(action, resource_spec)
      run_context.notifies_before(Notification.new(resource_spec, action, self))
    end

    # Helper for #notifies
    def notifies_immediately(action, resource_spec)
      run_context.notifies_immediately(Notification.new(resource_spec, action, self))
    end

    # Helper for #notifies
    def notifies_delayed(action, resource_spec)
      run_context.notifies_delayed(Notification.new(resource_spec, action, self))
    end

    #
    # Get the current actual value of this resource.
    #
    # This does not cache--a new value will be returned each time.
    #
    # @return A new copy of the resource, with values filled in from the actual
    #   current value.
    #
    def current_value
      provider = provider_for_action(Array(action).first)
      if provider.whyrun_mode? && !provider.whyrun_supported?
        raise "Cannot retrieve #{self.class.current_resource} in why-run mode: #{provider} does not support why-run"
      end
      provider.load_current_resource
      provider.current_resource
    end

    # These methods are necessary for new resources to initialize old ones properly
    attr_reader :resource_initializing
    def resource_initializing=(value)
      if value
        @resource_initializing = value
      else
        remove_instance_variable(:@resource_initializing)
      end
    end
  end
end
