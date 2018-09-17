#!/usr/bin/env ruby

# This script extracts the first occuring numbers from each line and prints and returns
# the sum of them.
# returns 0 on error
#
# author: langenhagen
# version: 17-08-05

if ARGV.empty?
  puts "Usage: #{__FILE__} <filename>"
  exit 0
end

input_file_name = ARGV[0]
unless File.exist? File.expand_path input_file_name
    puts "Given argument must be a valid path to a file."
    exit 0
end

# --------------------------------------------------------------------------------------------------
def calculate_total_sum_from_last_number_per_line(input_file)
    # Reads the given file and accumulates the last numbers
    # that can be found in each line, if there are any.
    # Params:
    # +input_file+:: The file that is to be read.
    total_sum = 0
    while (line = input_file.gets)
        # get the substring from the last whitespace to the string's end,
        # extract the numberic substring from it, convert it to an integer
        # and add it to the total sum :)

        puts line.scan(/\d+/)[-1].to_i

        total_sum += line.scan(/\d+/)[-1].to_i
    end
    return total_sum
end
# --------------------------------------------------------------------------------------------------


begin
    input_file = File.new(input_file_name, "r", :encoding => 'ISO-8859-1')
    total_sum = calculate_total_sum_from_last_number_per_line(input_file)
    input_file.close
rescue => err
    puts "Exception while reading file: #{err}"
    exit 0
end

puts total_sum
exit total_sum