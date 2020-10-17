module ToDo
    class ListFile
      
      @@filename = 'td_list.txt'
      
      def initialize(filename="")
        filename ||= @@filename
        # locates list file in $app_root
        dirname = ToDo::ListDir.dirname
        @filepath = File.join($app_root, dirname, filename)
        if File.exists?(@filepath)
          # confirms that it is readable and writable
          if !File.readable?(@filepath)
            abort("List file exists but is not readable.")
          end
          if !File.writable?(@filepath)
            abort("List file exists but is not writable.")
          end
        else
          # or creates a new file in $app_root
          #   uses File.open in write mode to create a brand new file
          File.open(@filepath, 'w')
          if !File.exists?(@filepath)
            abort("List file does not exist and could not be created.")
          end
        end
        # if success, return self (the instance File.open(@filepath, 'w') just created for controller as reference from then on), otherwise exit program
        self
      end
      
      def view
        puts "\nThe items in the list are:\n\n".upcase
        # reeads from list file
        # can use File.new or open in read mode
        # adds numbers next to list items
        file = File.new(@filepath, 'r')
        file.each_line.with_index do |line, i|
        # while loop will do here
          puts "#{i+1}: #{line}"
        end
        file.close
      end
      
      def add
        puts "\nYou will be adding an item to the list:\n\n".upcase
        # appends item to the end of the list.
        # can use File.new or open in read mode
        puts "Enter the " + "content".colorize(:yellow) + " of the item and hit " + "return".colorize(:light_green)
        print ">> "
        new_item = STDIN.gets.chomp
        system("clear")
        File.open(@filepath, 'a') do |file|
          file << new_item
          file << "\n" # because we used #chomp above
          #optional close
        end
        puts "List updated.".colorize(:green)
      end
      
      def edit(args=[])
        puts "\nYou will be editing an item in the list:\n\n".upcase
        # gets the item position from the args ("edit n")
        position = args.first.to_i
        if position < 1
          puts "Oops, my bad. You should also include the " + "number".colorize(:yellow) + " of the item. (e.g.: edit 2)"
          return
        end
        # reads list file and make sure that item exists
        # uses File.readlines
        # returns not found message if item does not exist
        lines = File.readlines(@filepath)
        if lines[position-1].nil?
          puts "Invalid item number."
          return
        end
        # output text of current list item again
        # asks user to type new content
        puts "Enter the new " + "content".colorize(:yellow) + " and hit " + "return".colorize(:light_green)
        puts "#{position}: #{lines[position-1]}"
        print ">> "
        new_item = gets
        system("clear")
        # writes list file with the new updated list
        # use File.write
        lines[position-1] = new_item
        data = lines.join
        File.write(@filepath, data)
        puts "List updated.".colorize(:green)
      end

      def delete(args=[])
        puts "\nYou will be deleting an item from the list:\n\n".upcase
        # deletes item from the list.
        position = args.first.to_i
        if position < 1
          puts "Sooory, should've reminded you to include the " + "number".colorize(:yellow) + " of the item. (e.g.: delete 7)"
          return
        end
         # reads list file and make sure that item exists
        #  uses File.readlines
        # returns not found message if item does not exist
        lines = File.readlines(@filepath)
        # p lines.class
        if lines[position-1].nil?
          puts "Invalid item number."
          return
        end
        puts "Enter the " + "content".colorize(:yellow) + " to confirm and hit " + "return".colorize(:light_green)
        puts "#{position}: #{lines[position-1]}"
        print ">> "
        delete_item = gets
        system("clear")
        # checks if the user input shares certain characters with the to be executed content
        if lines.any?{|line| line.include?(delete_item)}
          lines.delete_at (position-1)
          data = lines.join
          File.write(@filepath, data)
          puts "List updated.".colorize(:green)
        else
          puts "Item not confirmed. Please try again."
          return
        end
      end
      
    end
  end
  