require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def score
    @word = params[:word]
    @letters = params[:letters]
    if validate(@word, @letters) && dictionary(@word)
      @response = "Congrats! #{@word.upcase} is an English word"
    elsif !dictionary(@word)
      @response = "Sorry but #{@word.upcase} doesn't seem to be an English word"
    elsif !validate(@word, @letters)
      @response = "Sorry but #{@word.upcase} can't be built from #{@letters}"
    end
  end

  def validate(word, letters)
    w_hash = Hash.new(0)
    word.upcase.split('').each { |letter| w_hash[letter] += 1 }

    l_hash = Hash.new(0)
    letters.split('').each { |letter| l_hash[letter] += 1 }
    word.upcase.split('').all? { |key| w_hash[key] <= l_hash[key] }
  end

  def dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary = JSON.parse(open(url).read)
    dictionary['found']
  end

  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample.upcase }
  end
end
