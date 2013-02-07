###
# EventReporter
# by Geoff Schorkopf
# Completed 02/07/2012
###

require "csv"

require_relative "help"
require_relative "clean"
require_relative "cache"

HEADERS = ["last_name", "first_name", "email", "zipcode",
					 "city", "state", "address", "phone"]

class EventReporter
	def initialize
		puts "EventReporter Initialized!"
		@cache = Cache.new
		@people = []
	end

	def run
		command = ""
	  	while command != "q"
	    	printf "Please enter command: "
	    	input = gets.chomp
	    	parts = input.split(" ")
	    	command = parts[0].to_s.downcase
	    	if parts.length >= 1
	    		instructions = parts[1..-1].join(" ").downcase
	    	end
	    	main_command_center(command, parts, instructions)
	  	end
	end

	def main_command_center(command, parts, instructions)
		case command
  		when "load"			then parts.length < 2 ? load_file : load_file(instructions)
  		when "help" 		then parts.length < 2 ? 
  										Help.help_listing : Help.help_command(instructions)
  		when "queue"		then parts.length < 2 ?
  										bad_command : @cache.queue_tree(instructions)
  		when "find" 		then parts.length < 3 ?
  										bad_command : find_tree(instructions)
  		when "add"			then parts.length < 3 ? 
  										bad_command : add_to_find(instructions)	
  		when "subtract"	then parts.length < 3 ? 
  										bad_command : subtract_from_find(instructions)
	    when "quit", "q"	then exit_message
  		else bad_command	end
	end

	def create_people_array(file)
		file.each do |row|
			person = {
								:last_name=>Clean.last_name(row[:last_name]),
								:first_name=>Clean.first_name(row[:first_name]),
								:email=>Clean.email(row[:email_address]),
								:zipcode=>Clean.zipcode(row[:zipcode]),
								:city=>Clean.city(row[:city]),
								:state=>Clean.state(row[:state]),
								:address=>Clean.address(row[:street]),
								:phone=>Clean.phone_number(row[:homephone])
							}
			@people << person
		end
		puts "#{@people.length} rows logged."
	end

	def load_file(file="event_attendees.csv")
		@people = []
		if File.exist?(file) == true
			@file = CSV.open(file, headers: true, header_converters: :symbol)
			puts "File loaded in!"
			create_people_array(@file)
			puts "Load complete!"
		else
			puts "File not found! Consider adding it to #{Dir.getwd}."
		end
	end

	def find_tree(string)
		parts_array = string.split(" ")
		if parts_array.length == 2
			find_single_parameter(parts_array.join(" "))
		else
			find_multiple_parameter(parts_array.join(" "))
		end
	end

	def find_single_parameter(string)
		parts = string.split(" ")
		att = parts[0]
		crit = parts[1]
		if HEADERS.include?(att)
			@cache.queue = @people.select {|key, value| key[att.to_sym].downcase == crit}
			puts "Added #{@cache.queue.length} entries."
		else bad_command
		end
	end

	def find_multiple_parameter(string)
		parts = string.split(" ")
		if (parts.include?("and") == true)
			if (parts.index("and") != 0) && (parts.index("and") != -1)
				advanced_find(parts) end
		else
			att = parts[0]
			crit = parts[1..-1].join(" ")
			if HEADERS.include?(att)
				@cache.queue=@people.select {|key, value| key[att.to_sym].downcase == crit}
				puts "Added #{@cache.queue.length} entries."
			else bad_command end
		end
	end

	def advanced_find(parts)
		split_point = parts.index("and")
		first_att = parts[0]
		first_crit = parts[1..(split_point-1)].join(" ")
		second_att = parts[(split_point+1)]
		second_crit = parts[(split_point+2)..-1].join(" ")
		if HEADERS.include?(first_att) && HEADERS.include?(second_att)
			@cache.queue = @people.select {|key, value| 
																		(key[first_att.to_sym].downcase == first_crit) && 
																		(key[second_att.to_sym].downcase == second_crit)}
			puts "Added #{@cache.queue.length} entries that match both criteria."
		else bad_command end
	end

	def add_to_find(string)
		if @cache.queue.empty? == true
			puts "You can't add to an empty queue!"
		else
			parts_array = string.split(" ")
			attribute = parts_array[0]
			criteria = parts_array[1..-1].join(" ")
			old_length = @cache.queue.length
			add_items = @people.select {|key, value| 
				key[attribute.to_sym].downcase == criteria}
			@cache.queue |= add_items
			new_length = @cache.queue.length-old_length
			puts "Appended #{new_length} entries."
		end
	end

	def subtract_from_find(string)
		if @cache.queue.empty? == true
			puts "You can't subtract from an empty queue!"
		else
			parts_array = string.split(" ")
			att = parts_array[0]
			criteria = parts_array[1..-1].join(" ")
			old_length = @cache.queue.length
			@cache.queue.delete_if {|key, value| key[att.to_sym].downcase == criteria}
			new_length = old_length-@cache.queue.length
			puts "Removed #{new_length} entries."
		end
	end
	
	def bad_command
		puts "I couldn't understand your request. Type 'help' for help listing."
	end

	def exit_message
		puts "Thank you for using EventReporter!"
		exit
	end

end

EventReporter.new.run







