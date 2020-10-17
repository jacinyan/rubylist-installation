require_relative 'cli'

module ToDo
    class ListDir
      
      @@dirname = 'td_lists'
  
      def self.dirname
        @@dirname
      end
      
      #getter method for refreshing
      attr_reader :files
      
      def initialize
        # finds directory or create if it doesn't exist
        # locates list directory in APP_ROOT
        @dirpath = File.join($app_root, @@dirname)
        if Dir.exists?(@dirpath)
          # confirms that it is readable and writable
          # it is a quirk that there is no built in method for Dir but an expedient through File
          if !File.readable?(@dirpath)
            abort("List directory exists but is not readable.")
          end
          if !File.writable?(@dirpath)
            abort("List directory exists but is not writable.")
          end
        else
          # or creates a new directory in APP_ROOT
          # uses Dir.mkdir
          Dir.mkdir(@dirpath)
          if !Dir.exists?(@dirpath)
            abort("List directory does not exist and could not be created.")
          end
        end
  
        refresh_cached_files
        
        # if success, returns the instance Dir.mkdir(@dirpath) just created, otherwise exit program
        self

      end
      
      def choose_list
        # displays list files with indices
        puts "-" * 90
        puts "#{$user_name}, how would you like to use your lists today?\n\n".upcase
        puts "Enter the " + "number".colorize(:yellow) + " of one list to work with."
        list
        puts "* Type " + "add".colorize(:red) + " to create a new list when neccessary" 
        puts "** Type any other key to proceed to next level for " + "exit".colorize(:light_green) + ","  
        puts "(c'tnd) note that this displays first list file by default" 
        # prompts user to choose a number
        print ">> "
        response = gets.chomp
        system("clear")
        # user can also type 'add' to add a new list
        if response == 'add'
          filename = add 
          # assigns the returned value 'name' of the method 'add' defined down below to a variable. 
        else
          number = response.to_i
          # defaults to first file if input is invalid
          number = 1 unless (1..@files.length).include?(number)
          filename = @files[number-1]
        end
        puts "Now using: #{filename}".colorize(:green)
        # returns filename so it can be loaded by ListFile in the controller ultimately
        filename

      end
      
      def list
        puts "+-------------------+------------------+"
        puts "| Number            | List             |"
        puts "+-------------------+------------------+"
          @files.each_with_index do |filename, i| 
            rows = []        
            rows << "#{i+1}: #{filename}".split(':')
            table = Terminal::Table.new :rows => rows, :style => {:width => 40}          
            puts table
        end
      end
      
      def add
        # prompts user to provide a new file name and creates it
        puts "Enter the " + "name".colorize(:yellow) + " of the list you would like to use"
        puts "Names should be lowercase with underscores.(e.g.: verb, noun_list, adj_of_adv.txt)"
        print ">> "
        response = gets.chomp
        system("clear")
        name = response.downcase.strip
        # ensures file name ends in '.txt'
        name << ".txt" unless name.end_with?('.txt')
        filepath = File.join(@@dirname, name)
        File.open(filepath, 'w')
        # refreshes cached files (or adds filename to @files)
        refresh_cached_files
        # returns filename so it can be loaded by ListFile
        name

      end
      
      def refresh_cached_files
        # stores the list of the files in this directory in @files
        # can use Dir.entries or Dir.glob
        # excludes "." files or directories
        # only returns filenames, not absolute or relative paths
        @files = Dir.glob("#{@@dirname}/*.txt")
        @files.reject! {|f| f.start_with?('.') }
        @files.reject! {|f| File.directory?(f)}
        @files.map! {|f| File.basename(f) }
      end
      
    end
  end
  
