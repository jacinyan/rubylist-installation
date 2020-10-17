Gem::Specification.new do |s|
    s.name        = 'ruby_list'
    s.version     = '0.0.1'
    s.date        = '2020-10-17'
    s.summary     = "My first gem"
    s.description = "A simple to-do list gem"
    s.authors     = ["Jacin Yan"]
    s.email       = 'jacinjiyan@gmail.com'
    s.files       = %w(
                        lib/ruby_list.rb
                        lib/ruby_list/cli.rb
                        lib/ruby_list/list_dir.rb
                        lib/ruby_list/list_file.rb
                    )
    s.homepage    = 'https://rubygems.org/gems/ruby_list'
    s.license       = 'MIT'
    s.executables = ['ruby_list']
    s.add_runtime_dependency "colorize", "~> 0.8.1"
    s.add_runtime_dependency "tty-prompt", "~> 0.22.0"
    s.add_runtime_dependency "terminal-table", "~> 1.8.0"
  end