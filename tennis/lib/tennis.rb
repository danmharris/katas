# frozen_string_literal: true

NEXT_SCORE = { 0 => 15, 15 => 30, 30 => 40 }.freeze

class UnknownPlayerError < StandardError; end

class Tennis
  attr_reader :players

  def initialize(*players)
    @players = players
    @score = Array.new(2).fill(0)
    @winner = nil
  end

  def score(player)
    index = index_for_player(player)
    @score[index]
  end

  def point(player)
    index = index_for_player(player)
    current_score = score(player)

    if current_score == :advantage || (!deuce? && current_score == 40)
      @winner = index
      return
    end

    if deuce?
      other_player_name = other_player(player)
      other_player_index = index_for_player(other_player_name)
      case score(other_player_name)
      when 40
        @score[index] = :advantage
      when :advantage
        @score[other_player_index] = 40
      end
      return
    end

    @score[index] = NEXT_SCORE[current_score]
  end

  def winner
    if @winner.nil?
      nil
    else
      @players[@winner]
    end
  end

  def finished?
    !winner.nil?
  end

  def deuce?
    @score.all? { |score| [40, :advantage].include?(score) }
  end

  private

  def index_for_player(player)
    index = @players.find_index(player)
    raise UnknownPlayerError if index.nil?

    index
  end

  def other_player(player)
    @players.find { |name| name != player }
  end
end
