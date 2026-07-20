module Bob

  def self.hey(remark)
    sanitized = remark.strip
    ends_with_question_mark = sanitized =~ /\?\z/
    is_all_uppercase = sanitized == sanitized.upcase
    contains_letters = sanitized =~ /[A-Z]+/

    case
    when sanitized.empty? then 'Fine. Be that way!' # silence
    when ends_with_question_mark && is_all_uppercase && contains_letters then "Calm down, I know what I'm doing!" # yelling question
    when ends_with_question_mark then 'Sure.' # question
    when is_all_uppercase && contains_letters then 'Whoa, chill out!' # yelling
    else
      'Whatever.'
    end
  end

end
