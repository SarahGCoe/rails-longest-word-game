require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    array = ('a'..'z').to_a + ('a'..'z').to_a + ('a'..'z').to_a
    @letters = array.sample(10)
  end

  def score
    guess = params[:guess]
    letters = params[:letters]
    if guess.chars.all? { |l| letters.include?(l) }
      real_word?(guess) ? @answer = "CONGRATULATIONS! #{guess} is valid word!"
      : @answer = "#{guess} is not English word."
    else
      @answer = "Sorry but #{guess} isn't in #{letters}"
    end
  end

  private

  def real_word?(guess)
    query = open("https://wagon-dictionary.herokuapp.com/#{guess}")
    response = JSON.parse(query.read)
    response['found']
  end
end
