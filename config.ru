# This file is used by Rack-based servers to start the application.

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

SafeYAML::OPTIONS[:default_mode] = :unsafe

require ::File.expand_path('../config/environment',  __FILE__)
run Labtool::Application
