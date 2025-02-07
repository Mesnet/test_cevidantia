# main.rb
require 'json'
require_relative 'level3'

INPUT_PATH = File.join(__dir__, 'data', 'input.json')
OUTPUT_PATH = File.join(__dir__, 'data', 'output.json')

if __FILE__ == $0
  # 1) Read the input file
  data_input = JSON.parse(File.read(INPUT_PATH))

  # 2) Instantiate Level3, passing in the JSON data
  level3 = Level3.new(data_input)

  # 3) Run the logic and retrieve the result hash
  result_hash = JSON.parse(level3.run)

  # 4) Write the result to data/output.json
  File.write(OUTPUT_PATH, JSON.pretty_generate(result_hash))

  puts "Level3 output has been generated in #{OUTPUT_PATH}"
end
