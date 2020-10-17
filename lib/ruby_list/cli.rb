require_relative 'list_dir'
require_relative 'list_file'

module Home
    class Controller

        #launches the application
        def init
            welcome_message
            name
            menu
            prompt
        end

        #displays app logo and descriptions
        def welcome_message
            puts "
            ┏━━━┓━━━━┏┓━━━━━━━┏┓━━━━━━━━┏┓━
            ┃┏━┓┃━━━━┃┃━━━━━━━┃┃━━━━━━━┏┛┗┓
            ┃┗━┛┃┏┓┏┓┃┗━┓┏┓━┏┓┃┃━┏┓┏━━┓┗┓┏┛
            ┃┏┓┏┛┃┃┃┃┃┏┓┃┃┃━┃┃┃┃━┣┫┃━━┫━┃┃━
            ┃┃┃┗┓┃┗┛┃┃┗┛┃┃┗━┛┃┃┗┓┃┃┣━━┃━┃┗┓
            ┗┛┗━┛┗━━┛┗━━┛┗━┓┏┛┗━┛┗┛┗━━┛━┗━┛
            ━━━━━━━━━━━━━┏━┛┃━━━━━━━━━━━━━━
            ━━━━━━━━━━━━━┗━━┛━━━━━━━━━━━━━━

            ".center(100).colorize(:cyan)
            sleep 2
        end

        def name
            puts "Welcome! Can I have your name please?"
            print ">> "
            $user_name= gets.chomp.strip
            system("clear")
        end

        #initialises the app 
        @@valid_actions = ['view', 'add', 'edit', 'delete','back', 'quit']

        def initialize
            @list_dir = ToDo::ListDir.new
        end

        def menu

            #same as back to list display when launched
            do_action('back', [])
            
            # input/action loop
            loop do
              action, args = get_action
              break if action == 'quit'
              result = do_action(action,args)
            end

        end

        def get_action
            action = ''
            until @@valid_actions.include?(action)
              puts "\nProceed with first 4 item actions, or exit the list or whole application with last 2:\n" + @@valid_actions.join(', ').colorize(:red) + "\n"
              print ">> "
              response = gets.chomp
              system("clear")
              args = response.downcase.strip.split(' ')
              action = args.shift
            end
            [action, args]
        end
            
        def do_action(action, args)
            case action
            when 'view'
                @list_file.view
            when 'add'
                @list_file.add
            when 'edit'
                @list_file.edit(args)
            when 'delete'
                @list_file.delete(args)
            when 'back'
                # activates create/select lists
                new_file = @list_dir.choose_list
                # receives returned file name, using the file name to create a new file object 
                @list_file = ToDo::ListFile.new(new_file)
                # displays
                @list_file.view
            else
                system("clear")
                puts "\nI don't understand that command. You will be redirected to last visited page in a few seconds...\n".colorize(:light_yellow)
                sleep(3)
            end
        end

        def prompt
            puts "#{$user_name}, before you really go, would you like to take a quiz?[Y/N] "
            confirmation = gets.chomp.strip
            system("clear")
            if confirmation == "N" || confirmation == "n" || confirmation == "no" || confirmation == "NO"
                goodbye_message
            elsif confirmation == "Y" || confirmation == "y" || confirmation == "yes" || confirmation == "YES"
                start_quiz
            else 
                puts "\nI don't understand the command. You'll be redirected to last visited page in a few seconds...\n".colorize(:light_yellow)
                sleep(3)
                system("clear")
                prompt
            end
        end
        
        # quiz
        def start_quiz 
        
            prompt = TTY::Prompt.new
        
            prompt.select("How often do you use the app)?", choices = %w(rarely sometimes always) )
            system("clear")

            prompt.select("Is the app user-friendly", choices = %w(Disagree Neutral Agree))
            system("clear")

            prompt.select("How would rate the app (in stars)?", choices = %w(1 2 3 4 5) )
            system("clear")

            prompt.select("Would you tell us more in detail via this adderess: jacinjiyan@gmail.com", choices = %w(No Unsure Yes) )
            system("clear")
            
            puts "Thank you for your feedback! It is now being uploaded, please wait..."
            sleep(3)
            system("clear")

            goodbye_message
            
        end 
        
        # exits the app
        def goodbye_message
            puts "
            ╔═══╗                                             ╔╗
            ║╔═╗║                                             ║║
            ║╚══╗╔══╗╔══╗    ╔╗ ╔╗╔══╗╔╗╔╗    ╔══╗╔══╗╔══╗╔═╗ ║║
            ╚══╗║║╔╗║║╔╗║    ║║ ║║║╔╗║║║║║    ║══╣║╔╗║║╔╗║║╔╗╗╚╝
            ║╚═╝║║║═╣║║═╣    ║╚═╝║║╚╝║║╚╝║    ╠══║║╚╝║║╚╝║║║║║╔╗
            ╚═══╝╚══╝╚══╝    ╚═╗╔╝╚══╝╚══╝    ╚══╝╚══╝╚══╝╚╝╚╝╚╝
                             ╔═╝║                               
                             ╚══╝                               
            ".colorize(:light_blue)
        end 

    end
end