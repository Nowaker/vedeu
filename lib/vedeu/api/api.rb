module Vedeu
  module API
    # Register an event by name with optional delay (throttling) which when
    # triggered will execute the code contained within the passed block.
    #
    # @param name  [Symbol] The name of the event which will be triggered later
    # @param delay [Fixnum|Float] Limits the execution of the triggered event to
    #   the delay in seconds, effectively throttling the event. A delay of 1.0
    #   will mean that even if the event is triggered multiple times a second
    #   it will only execute once for that second. Triggers pulled inside the
    #   delay are discarded.
    # @param block [Proc] The event to be executed when triggered. This block
    #   could be a method call, or the triggering of another event, or sequence
    #   of either/both.
    #
    # @example
    #   Vedeu.event :my_event do |some, args|
    #     ... maybe some code here ...
    #
    #     Vedeu.trigger(:my_other_event)
    #   end
    #
    #   Vedeu.event(:my_other_event, 0.25)
    #     ... maybe some code here ...
    #   end
    #
    # @return [Hash]
    def event(name, delay = 0, &block)
      Vedeu.events.event(name, delay, &block)
    end

    # Find out how many lines the current terminal is able to display.
    #
    # @example
    #   Vedeu.height
    #
    # @return [Fixnum] The total height of the current terminal.
    def height
      Terminal.height
    end

    # Register an interface by name which will display output from a event or
    # command. This provides the means for you to define your application's
    # views without their content.
    #
    # @param name  [String] The name of the interface. Used to reference the
    #   interface throughout your application's execution lifetime.
    # @param block [Proc] A set of attributes which define the features of the
    #   interface. TODO: More help.
    #
    # @example
    #   Vedeu.interface 'my_interface' do
    #      ... some interface attributes like width and height ...
    #   end
    #
    # @return [Hash]
    def interface(name, &block)
      API::Interface.define({ name: name }, &block)
    end

    # Simulate keypresses in your application. TODO: More help.
    #
    # @param key [String|Symbol] A simulated keypress. Escape sequences are also
    #   supported. Special keys like the F-keys are named as symbols; i.e. `:f4`
    #
    # @return []
    def keypress(key)
      trigger(:key, key)
      trigger(:_log_, "Key: #{key}")
      trigger(:_mode_switch_) if key == :escape
    end

    # Write a message to the Vedeu log file located at `$HOME/.vedeu/vedeu.log`
    #
    # @param message [String] The message you wish to emit to the log
    #   file, useful for debugging.
    #
    # @return [TrueClass]
    def log(message)
      API::Log.logger.debug(message)
    end

    # Trigger a registered or system event by name with arguments.
    #
    # @param name [Symbol] The name of the event you wish to trigger.
    #   The event does not have to exist.
    # @param args [Array] Any arguments the event needs to execute correctly.
    #
    # @example
    #   Vedeu.trigger(:my_event, :oxidize, 'nitrogen')
    #
    # @return [Array]
    def trigger(name, *args)
      Vedeu.events.trigger(name, *args)
    end

    # Use attributes of another interface whilst defining one. TODO: More help.
    #
    # @param name [String] The name of the interface you wish to use. Typically
    #   used when defining interfaces to share geometry.
    #
    # @example
    #   Vedeu.interface 'main_screen' do
    #     ... some attributes ...
    #     width use('my_interface').width
    #     x     use('my_interface').east(1)
    #   end
    #
    # @return [Vedeu::Interface]
    def use(name)
      Vedeu::Interface.new(Vedeu::Store.query(name))
    end

    # Define a view (content) for an interface. TODO: More help.
    #
    # @param name [String] The name of the interface you are targetting for this
    #   view.
    # @param block [Proc] The directives you wish to send to this interface.
    #
    # @example
    #   view 'my_inteface' do
    #     ... some view attributes ...
    #   end
    #
    # @return [Hash]
    def view(name, &block)
      {
        interfaces: [
          API::Interface.build({ name: name }, &block)
        ]
      }
    end

    # Instruct Vedeu to treat contents of block as a single composition.
    # TODO: More help.
    #
    # @param block [Proc] Instructs Vedeu to treat all of the 'view' directives
    #   therein as one instruction. Useful for redrawing multiple interfaces at
    #   once.
    #
    # @example
    #   views do
    #     view 'my_interface' do
    #       ... some attributes ...
    #     end
    #     view 'my_other_interface' do
    #       ... some other attributes ...
    #     end
    #   end
    #
    # @return [Hash]
    def views(&block)
      API::Composition.build(&block)
    end

    # Find out how many columns the current terminal is able to display.
    #
    # @example
    #   Vedeu.width
    #
    # @return [Fixnum] The total width of the current terminal.
    def width
      Terminal.width
    end

    # @api private
    def events
      @events ||= API::Events.new do
        event(:_log_)         { |msg| Vedeu.log(msg)      }
        event(:_exit_)        { Vedeu.shutdown            }
        event(:_mode_switch_) { fail ModeSwitch           }
        event(:_clear_)       { Terminal.clear_screen     }
        event(:_refresh_)     { Buffers.refresh_all       }
        event(:_keypress_)    { |key| Vedeu.keypress(key) }
      end
    end

    # @api private
    def shutdown
      trigger(:_cleanup_)

      fail StopIteration
    end
  end

  extend API
end
