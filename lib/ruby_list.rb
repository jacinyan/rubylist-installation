require 'colorize'
require 'colorized_string'
require "tty-prompt"
require 'terminal-table'

require_relative 'ruby_list/cli'


class Rubylist

    def initialize
        Dir.chdir(File.dirname(__FILE__))
        $app_root = File.expand_path(File.dirname(__FILE__))
        @cli = Home::Controller.new
        
    end

    def launch
        @cli.init 
    end  
end
    
