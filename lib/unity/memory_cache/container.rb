# frozen_string_literal: true

module Unity
  module MemoryCache
    class Container
      class Entry
        # @return [Object]
        attr_accessor :value

        # @return [Integer]
        attr_accessor :ttl

        # @param value [Object]
        # @param ttl [Integer]
        def initialize(value, ex: nil, exat: nil)
          @value = value
          @ttl = \
            if !ex.nil?
              Process.clock_gettime(Process::CLOCK_REALTIME, :second) + ex
            elsif !exat.nil?
              exat
            end
        end

        def expired?
          return false if @ttl.nil?

          @ttl < Process.clock_gettime(Process::CLOCK_REALTIME, :second)
        end
      end

      def initialize(entry_expires_after: nil, auto_clean_thread: true, auto_clean_interval: 60)
        @storage = {}
        @entry_expires_after = entry_expires_after
        @mutex = Mutex.new
        @auto_clean_thread = nil
        @closed = false
        spawn_auto_clean_thread(auto_clean_interval) if auto_clean_thread == true
      end

      def closed?
        @closed
      end

      def close
        @mutex.synchronize do
          @auto_clean_thread&.kill
          @storage = nil
          @closed = true
        end
      end

      def cleanup
        @mutex.synchronize do
          @storage.keys.each do |key|
            next unless @storage[key].expired?

            @storage.delete(key)
          end
        end
      end

      def [](key)
        get(key)
      end

      def []=(key, value)
        set(key, value)
      end

      def ttl(key)
        entry = @storage[key]
        return if entry.nil? || entry.ttl.nil? || entry.expired?

        entry.ttl - Process.clock_gettime(Process::CLOCK_REALTIME, :second)
      end

      def set(key, value, ex: nil, exat: nil)
        @mutex.synchronize do
          @storage[key] = Entry.new(value, ex: ex || @entry_expires_after, exat: exat)
        end

        true
      end

      def delete(key)
        @mutex.synchronize do
          @storage.delete(key)
        end

        true
      end

      def get(key, default_value = nil)
        entry = @storage[key]
        return default_value if entry.nil? || entry.expired?

        entry.value
      end

      def keys
        @storage.keys.freeze
      end

      def values
        @storage.values.freeze
      end

      private

      def spawn_auto_clean_thread(auto_clean_interval)
        @auto_clean_thread = Thread.start do
          loop do
            break if closed?

            cleanup
            sleep(auto_clean_interval)
          end
        end
      end
    end
  end
end
