require "active_support/all"

class Cache

  attr_accessor :queue

  def initialize
    @queue = []
  end

  def queue_tree(string)
    parts = string.split(" ")
    attribute = parts[0..1].join(" ").downcase
    if parts.length == 1
      case attribute
        when "count"  then queue_count
        when "clear"  then queue_clear
        when "print"  then queue_print
        else bad_command
      end
    elsif attribute == "print by"
      criteria = parts[2..-1].join(" ").downcase
      queue_print_by(criteria)
    elsif attribute == "save to"
      filename = parts[2..-1]
      queue_save_to(filename)
    else 
      bad_command
    end
  end

  def queue_count
    puts "The current queue is #{@queue.length} entries long."
  end

  def queue_clear
    @queue = []
    puts "Queue cleared!"
  end

  def queue_print
    if @queue.empty? == true
      puts "Queue is currently empty. Nothing to print."
    else
      print_headers
      print_queue
    end
  end

  def queue_print_by(criteria)
    if criteria == ""
      bad_command
    else
      sort_queue(criteria)
    end
  end

  def sort_queue(attribute)
    att_array = %w[last_name first_name email zipcode city state address phone]
    if att_array.include? attribute
      @queue = @queue.sort_by do |person|
        person[attribute.to_sym].downcase
      end
      queue_print
    else 
      bad_command
    end
  end

  def print_headers
    column = find_column_lengths
    puts  "LAST NAME".ljust(column[:last_name], " ")+
          "FIRST NAME".ljust(column[:first_name], " ")+
          "EMAIL".ljust(column[:email], " ")+
          "ZIPCODE".ljust(column[:zipcode], " ")+
          "CITY".ljust(column[:city], " ")+
          "STATE".ljust(column[:state], " ")+
          "ADDRESS".ljust(column[:address], " ")+
          "PHONE"
  end

  def print_queue
    column = find_column_lengths
    counter = 0
    @queue.each do |person|
      if (counter != 0) && (counter % 10 == 0)
        puts "Showing files #{(counter+1) - 10} - #{counter} of #{@queue.size}"
        input = ""
        while input != "\n"
          puts "Press return to scroll records. Type 'exit' to quit print."
          input = gets end
      end
      print_names(person, column)
      counter += 1
    end
  end

  def print_names(person, column)
    puts  person[:last_name].titleize.ljust(column[:last_name], " ")+
          person[:first_name].titleize.ljust(column[:first_name], " ")+
          person[:email].ljust(column[:email], " ")+
          person[:zipcode].ljust(column[:zipcode], " ")+
          person[:city].titleize.ljust(column[:city], " ")+
          person[:state].upcase.ljust(column[:state], " ")+
          person[:address].titleize.ljust(column[:address], " ")+
          person[:phone]
  end

  def queue_save_to(filename)
    if filename.length != 1
      bad_command
    else
      file = filename[0].downcase
      File.open(file,'w') do |file|
        file.puts "first_Name,last_Name,Email_Address,"+
        "HomePhone,Street,City,State,Zipcode"
        @queue.each do |person|
          file.puts "#{person[:first_name]},#{person[:last_name]},"+
          "#{person[:email]},#{person[:phone]},#{person[:address]},"+
          "#{person[:city]},#{person[:state]},#{person[:zipcode]}"
        end
      end
      puts "File saved as #{file}!"
    end
  end

  def find_column_lengths
    lengths_hash = Hash.new(0)
    @queue.each do |person|
      HEADERS.each do |header|
        if person[header.to_sym].length > lengths_hash[header.to_sym]
          lengths_hash[header.to_sym] = person[header.to_sym].length+2
        end
        if lengths_hash[header.to_sym] > header.length+2
          lengths_hash[header.to_sym]
        else lengths_hash[header.to_sym] = header.length+2
        end
      end
    end
    return lengths_hash
  end

  def bad_command
    puts "I couldn't understand your request. Type 'help' for help listing."
  end

end