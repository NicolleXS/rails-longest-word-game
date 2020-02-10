require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @score = ''
    @letters = params[:grid]
    @word = params[:word]
    if included?(@word.upcase, @letters)
      if english_word?
        @score = "Congratulations! #{@word} is a valid English word!"
      else
        @score = "Sorry but #{@word} does not seem to be a valid word..."
      end
    else
      @score = "Sorry but #{@word} can't be built out of  #{@letters}"
    end
  end
end

def english_word?
  response = open("https://wagon-dictionary.herokuapp.com/#{@word}")
  json = JSON.parse(response.read)
  json['found']
end

def included?(guess, grid)
  guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
end
