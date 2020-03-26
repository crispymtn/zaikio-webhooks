require "zaikio/webhook/configuration"

module Zaikio
  module Webhook
    class << self
      attr_accessor :configuration

      def configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end
    end
  end
end
