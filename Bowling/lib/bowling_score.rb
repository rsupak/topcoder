# calculates bowling scores with bonuses
def bowling_score(scores)
  scores = scores.split(' ')
  scores = scores.map { |score| score.split('') }
  strike_locs, spare_locs = locate_strikes_and_spares(scores[0..7])
  # score open frames
  opens = score_open_frames(scores[0..7])

  # score spares
  spares = score_spares(scores, spare_locs)

  # score strikes
  strikes = score_strikes(scores, strike_locs)

  # score frames nine and ten
  nine = (scores.length == 10 ? score_frame_9(scores) : 0)
  ten = (scores.length == 10 ? score_frame_10(scores[9]) : 0)
  opens + strikes + spares + nine + ten
end

# helper method to identify indices of strikes and spares within the scores
def locate_strikes_and_spares(scores)
  spare_locs = []
  strike_locs = []
  scores.each.with_index do |score, i|
    spare_locs << i if score[1] == '/'
    strike_locs << i if score[0] == 'X'
  end
  [strike_locs, spare_locs]
end

# helper method to score open frames (frames without strikes or spares)
# only scores frames 1 - 8
def score_open_frames(scores)
  score = 0
  scores.each do |frame|
    unless frame.include?('/') || frame.include?('X')
      score += frame.map(&:to_i).sum
    end
  end
  score
end

# helper method used to score spares in frames 1 - 8
# returns 20 if next roll is a strike, else returns 10 + the next roll
def score_spares(scores, spare_locs)
  score = 0
  spare_locs.each do |loc|
    score += (scores[loc + 1][0] == 'X' ? 20 : 10 + scores[loc + 1][0].to_i)
  end
  score
end

# helper method used to score strikes in frames 1 - 8
# returns a perfect game if all rolls are strikes
# returns total of all the strike combinations (designated by categories below)
def score_strikes(scores, strike_locs)
  score = 0
  # perfect game
  return 300 if strike_locs.length == 10

  strike_locs.each do |loc|
    next unless loc <= 8

    # 3 strikes
    score += 30 if scores[loc + 1][0] == 'X' && scores[loc + 2][0] == 'X'

    # 2 strikes and a 3rd roll
    if scores[loc + 1][0] == 'X' && scores[loc + 2][0] != 'X'
      score += 20 + scores[loc + 2][0].to_i

    # strike and a spare
    elsif scores[loc + 1].include?('/')
      score += 20
    end

    # strike + 2 rolls (less than a spare)
    unless scores[loc + 1][0] == 'X' || scores[loc + 1][1] == '/'
      score += 10 + scores[loc + 1].map(&:to_i).sum
    end
  end
  score
end

# helper method to score frame 9
# frame 9 has special circumstances because from 10 can accumulate
# up to 3 strikes. If frame 9 is a strike, calculates with the first 2 rolls
# of frame 10, if it is a spare, calculates with the first roll of frame 10
# else calculates frame 9 as an open frame.
def score_frame_9(scores)
  # Frame 9 is open
  unless scores[8].include?('X') || scores[8].include?('/')
    return scores[8].map(&:to_i).sum
  end

  # Frame 9 == Strike
  if scores[8][0] == 'X'
    return 30 if scores[9][0] == 'X' && scores[9][1] == 'X'
    return 20 + scores[9][1].to_i if scores[9][0] == 'X'
    return 20 if scores[9][1] == '/'

    return 10 + scores[9].map(&:to_i).sum

  # Frame 9 == Spare
  elsif scores[8].include?('/')
    return 10 + scores[9][0].to_i
  end
end

# helper method used to calculate bonus points of frame 10

def score_frame_10(frame)
  # Open frame
  return frame[0].to_i + frame[1].to_i if frame.length == 2
  # X X X
  return 30 if frame[1] == 'X' && frame[2] == 'X'
  # X X <0-9>
  return 20 + frame[3].to_i if frame[1] == 'X'
  # X <0-9> /
  return 20 if frame[0] == 'X' && frame[2] == '/'
  # X <0-9> <0-9>
  return 10 + frame[1..2].map(&:to_i).sum if frame[0] == 'X'
  # <0-9> / X
  return 20 if frame[1] == '/' && frame[2] == 'X'
  # <0-9> / <0-9>
  return 10 + frame[2].to_i if frame[1] == '/' && frame[2] != 'X'
end

scores = '3/ 14 35 X 34 45 X 70 03 X3/'
p bowling_score(scores)