def translate_moon_phase(phase)
  labels = {
    :new => "nouvelle lune",
    :waxing_crescent => "premier croissant",
    :first_quarter => "premier quartier",
    :waxing_gibbous => "lune gibbeuse croissante",
    :full => "pleine lune",
    :waning_gibbous => "lune gibbeuse croissante",
    :last_quarter => "dernier quartier",
    :waning_crescent => "dernier croissant"
  }
  labels[phase]
end
