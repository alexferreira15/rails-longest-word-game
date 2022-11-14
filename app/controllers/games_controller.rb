require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    arr = ('A'..'Z').to_a
    @letters = arr.sample(10)
  end

  def chars_exist?
    @letters = params[:letters].split
    params[:word].chars.all? { |letter| params[:word].count(letter) <= @letters.count(letter) }
  end

  def grid_validation?
    # validação 2 - cada letra da palavra aparece na grid
    @letters = params[:letters].split
    params[:word].upcase.chars.all? { |letter| @letters.include? letter }
  end

  def en_word_validation?
    # validação 1 - se a palavra é EN
    url = URI.open("https://wagon-dictionary.herokuapp.com/#{params[:word]}")
    json = JSON.parse(url.read)
    json['found']
  end

  def score
    if !en_word_validation?
      @score = 0
      @message = 'Invalid Word! Not an english word'
    elsif !grid_validation? && !chars_exist?
      @score = 0
      @message = 'Invalid Word! Not in the grid'
    else
      @score = (params[:word].size * 2)
      @message = 'Well Done!'
    end

    #   if chars_exist? && grid_validation?
    #     if en_word_validation?
    #       @score = (params[:word].size * 2)
    #       @message = 'Well Done!'
    #     else
    #       @score = 0
    #       @message = 'Invalid Word! Not an english word'
    #     end
    #   else
    #     @score = 0
    #     @message = 'Invalid Word! Not in the grid'
    #   end
  end
end
