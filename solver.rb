require 'optparse'
require_relative 'maze_solver'

options = {
    :port => 9999,
    :hostname => 'localhost',
    :name => 'Ruby Solver'
}

option_parser = OptionParser.new do |opts|
  opts.on("-p PORT") do |port|
    options[:port] = port.to_i
  end

  opts.on("-h HOSTNAME") do |hostname|
    options[:hostname] = hostname
  end

  opts.on("-n NAME") do |name|
    options[:name] = name.to_i
  end
end

option_parser.parse!

solver = MazeSolver.new(options[:hostname], options[:port], options[:name])
solver.start