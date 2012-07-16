# -*- encoding: utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), "spec_helper"))

describe Answerer do
  let (:moon) { Moon.new }
  subject { Answerer.new(:moon) }

  it 'answers the perihelie' do
    subject.answer("Quel est le périhélie ?").should eq("363 104 km")
  end

  it 'answers the aphelie' do
    subject.answer("Quel est le aphélie ?").should eq("405 696 km")
  end

  it 'ignores the case' do
    subject.answer("PÉRIHÉLIE ?").should eq("363 104 km")
  end

  it 'answers the first man on the Moon' do
    subject.answer("Premier homme à marcher sur la Lune ?").should eq("Neil Armstrong, le 21 juillet 1969, à 2 h 56 UTC — http://tinyurl.com/l9lafy")
  end

  it 'returns the moon phase' do
    moon = double('moon')
    moon.should_receive(:phase).and_return(:full)
    answerer = Answerer.new(moon)
    answerer.answer("phase").should eq("pleine lune")
  end
end
