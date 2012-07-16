# -*- encoding: utf-8 -*-
require 'helpers'

class Answerer
  def initialize(moon)
    @moon = moon
  end

  def answer(question)
    question = question.encode('UTF-8')

    text = nil
    if question =~ /phase/i
      text = translate_moon_phase(@moon.phase)
    elsif question =~ /périhélie/i
      text = "363 104 km"
    elsif question =~ /aphélie/i
      text = "405 696 km"
    elsif question =~ /premier\s+homme.*march.*/i
      text = "Neil Armstrong, le 21 juillet 1969, à 2 h 56 UTC — http://tinyurl.com/l9lafy"
    end

    text
  end
end
