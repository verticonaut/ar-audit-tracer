require 'rubygems'
require 'test/unit'
require 'fileutils'
require 'active_record'
require 'logger'

# ------------------------------------------------------
# Setup AR environment
# ------------------------------------------------------

# Define connection info
ActiveRecord::Base.configurations = {
  "test" => {
    :adapter  => 'sqlite3',
    :database => ':memory:'
  }
}
ActiveRecord::Base.establish_connection("test")

# Setup logger
tmp = File.expand_path('../../tmp', __FILE__)
FileUtils.mkdir_p(tmp)
ActiveRecord::Base.logger = Logger.new("#{tmp}/debug.log")


# ------------------------------------------------------
# Inject audit-trascer
#   and setup test schema
#   and define models used in tests
# ------------------------------------------------------
require "ar-audit-tracer"

require "resources/schema.rb"
require "resources/models.rb"
