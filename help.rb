module Help
  def self.help_listing
    self.breaker
    puts "Function".ljust(60, " ") + "Input command"
    self.breaker
    puts "Load new document".ljust(60, " ") + "load <filename.csv>"
    puts "Open full help listing".ljust(60, " ") + "help"
    puts "Open help for specific command".ljust(60, " ") + "help <command>\n"+
    "Outputs number of records in current queue".ljust(60, " ") + "queue count"
    puts "Empty the current queue".ljust(60, " ") + "queue clear"
    puts "Print table of current queue".ljust(60, " ") + "queue print"
    puts self.help_listing2
  end

  def self.help_listing2
    puts "Print sorted table of current queue".ljust(60, " ")+
    "queue print by <attribute>\n"+
    "Export queue to file".ljust(60, " ")+"queue save to <filename.csv>\n"+
    "Add to queue with attributes matching specific criteria".ljust(60, " ")+
    "find <attribute> <criteria>\n"+
    "Quit EventReporter".ljust(60, " ") + '"q" or "quit"'
    self.breaker
    puts "Attribute list: #{HEADERS}"
    puts "Criteria can include anything, such as 'Robert' for first_name."
    puts "Note: Commands, attributes, and criteria are not case-sensitive."
    puts "Special note for find: Try 'find <attribute1> <criteria1>"+
    "AND find <attribute2> <criteria2>'!"
    self.breaker
  end

  def self.help_command(instructions)
    case instructions
    when "load"           then self.load                            
    when "help"           then self.help
    when "queue count"    then self.queue_count
    when "queue clear"    then self.queue_clear
    when "queue print"    then self.queue_print
    when "queue print by" then self.queue_print_by
    when "queue save to"  then self.queue_save_to             
    when "find"           then self.find      
    when "q"              then self.quit                                
    when "quit"           then self.quit
    else puts "No such command could be found. Type 'help' for full listing."
    end
  end

  def self.load
    self.breaker
    puts "Function: Load new document (type 'load <filename>')."
    puts "Example command: load event_attendees.csv"
    self.breaker
  end

  def self.help
    self.breaker
    puts "Function: Opens full help listing"
    puts "Example command: help"
    self.breaker
  end

  def self.queue_count
    self.breaker
    puts "Function: Outputs number of records in current queue."
    puts "Example command: queue count"
    self.breaker
  end

  def self.queue_clear
    self.breaker
    puts "Function: Empty the current queue."
    puts "Example command: queue clear"
    self.breaker
  end

  def self.queue_print
    self.breaker
    puts "Function: Print table of current queue."
    puts "Example command: queue print"
    self.breaker
  end

  def self.queue_print_by
    self.breaker
    puts "Function: Print sorted table of current queue"+ 
    "(type 'queue print by <attribute>')."
    puts "Example command: queue print by last_name"
    puts "Attribute list: #{HEADERS}"
    self.breaker
  end

  def self.queue_save_to
    self.breaker
    puts "Function: Export current queue (type 'queue save to <filename>')."
    puts "Example command: queue save to john_by_state.csv"
    self.breaker
  end

  def self.find
    self.breaker
    puts "Function: Imports files to queue with all matching"+ 
    " records (type 'find <attribute> <criteria>')."
    puts "Example command: find first_name mary"
    puts "Attribute list: #{BREAKERS}"
    puts "Note:\tThis command deletes previous queue."
    puts "\tYou may also find entries that match multiple criteria using AND."
    self.breaker
  end

  def self.quit
    self.breaker
    puts "Function: Quits EventReporter."
    puts "Example command: q"
    self.breaker
  end

  def self.breaker
    puts "-"*90
  end
end
