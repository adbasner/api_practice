# Build a terminal dictionary app
# Create a new ruby file called dictionary_app.rb
# The program should ask the user to enter a word, then use the wordnik API to show the word's definition, top example, and pronunciation: http://developer.wordnik.com/docs.html#!/word
# Bonus: Write your program in a loop such that the user can keep entering new words without having to restart the program. Give them the option of entering q to quit.

require 'unirest.rb'

class Dictionary
  attr_reader :word

  def get_word
    puts "Enter a word to search for.  Type in q to quit."
    @word = gets.downcase.chomp
    p word
    if word == "q"
      system "clear"
      puts "Goodbye!!!!"
      exit
    else
      system "clear"
    end
  end

  def get_top_example
    top_example_response = Unirest.get("https://api.wordnik.com/v4/word.json/#{word}/topExample?useCanonical=false&api_key=apikey")
    top_example_response.body
  end

  def get_definitions
    definition_response = Unirest.get("https://api.wordnik.com/v4/word.json/#{word}/definitions?limit=200&includeRelated=false&useCanonical=false&includeTags=false&api_key=apikey")
    definition_response.body
  end


  def get_pronunciations
    pronunciation_response = Unirest.get("https://api.wordnik.com/v4/word.json/#{word}/pronunciations?useCanonical=false&limit=50&api_key=apikey")
    pronunciation_response.body
  end

  def print_pronunciations
    the_definitions = get_pronunciations
    the_definitions.each_with_index do |pronuciation, i|
      current_pronunciation = pronuciation['raw']
      puts "#{i + 1}. #{current_pronunciation}"
    end
  end

  def print_definitions
    the_definitions = get_definitions
    the_definitions.each_with_index do |definition, i|
      current_definition = definition['text']
      puts "#{i + 1}. #{current_definition}"
    end
  end

  def print_top_example
    puts get_top_example['text']
  end

  # this does a lot, probably should have called it 'print_definitions_pronunciations_and_top_example'
  def print_info
    if get_definitions[0] == nil
      puts "Invalid word"
    else
      # output for terminal, uses dashes for cleaner screen
      puts "-" * 20
      puts "You entered #{word}."
      `say #{word}`
      puts "-" * 20
      puts "We found the following definitions:"
      print_definitions
      puts "-" * 20
      puts "The best example usage is:"
      print_top_example
      puts "-" * 20
      puts "We found the following pronunciations:"
      print_pronunciations
      puts "-" * 20
    end
  end

  def run
    while true
      get_word
      print_info
    end
  end
end


dictionary = Dictionary.new
dictionary.run