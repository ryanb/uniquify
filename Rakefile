require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('uniquify', '0.2.0') do |p|
  p.description    = "Generate a unique token with Active Record."
  p.url            = "http://github.com/ryanb/uniquify"
  p.author         = ["Ryan Bates", "Peter Brindisi"]
  p.email          = ["ryan@railscasts.com", "npj@frestyl.com"]
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
