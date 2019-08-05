require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = %w[A E I O U Y]

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    guess = params[:guess].upcase
    letters = params[:letters]
    included = included?(guess, letters)
    real_word = real_word?(guess)
    @answer = included ? real_word : "Sorry but #{guess} isn't in #{letters}"
    @score = guess.size
    session[:score] += @score
  end

  private

  def real_word?(guess)
    query = open("https://wagon-dictionary.herokuapp.com/#{guess}")
    response = JSON.parse(query.read)
    response['found'] ? "CONGRATULATIONS! #{guess} is valid word!"
                      : "#{guess} is not English word."
  end

  def included?(guess, letters)
    guess.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end
end


  # def new
  #   array = ('a'..'z').to_a + ('a'..'z').to_a + ('a'..'z').to_a
  #   @letters = array.sample(10)
  # end
