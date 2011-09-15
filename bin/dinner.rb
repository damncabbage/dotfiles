#!/usr/bin/env ruby
#
# ruby dinner.rb [number-of-dinners]
#

require 'rubygems';
require 'open-uri';
require 'hpricot';

recipes = Integer(ARGV[0] || 6)

recipes.times do |i|
  doc = open("http://whatthefuckshouldimakefordinner.com"){ |f| Hpricot(f) }

  (doc/"dl").each do |e|
    puts
    puts "#{e.inner_text.strip}:"
    puts
    break
  end unless i > 0

  (doc/"dt/a").each do |e|
    puts " * #{e.inner_text}"
    puts "   <#{e['href']}>"
    puts
  end
end

