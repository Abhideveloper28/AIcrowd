# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

rackapp = Rack::Builder.app do
  run Rails.application
end
run rackapp
