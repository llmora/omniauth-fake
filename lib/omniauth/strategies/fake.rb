require 'omniauth'
require 'yaml'

module OmniAuth
  module Strategies
    class Fake
      include OmniAuth::Strategy
      option :dotfiles, File.join(ENV['HOME'], '.omniauth-fake')

      def request_phase
        # TODO read all identities
        # TODO populate @@identities
        [@options[:dotfiles]].flatten.each do |file|
          # read the file etc...
        end
        # TODO list all identities
      end

      def callback_phase
        # #TODO populate @identity
      end

      uid  { @identity['uid']  }
      info { @identity['info'] }
      extra {
        { :raw_info => @identity['raw_info'] }
      }

    end
  end
end
