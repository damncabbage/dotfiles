# vi: ft=ruby

if defined?(PryByebug)
  [
    %w(c continue),
    %w(s step),
    %w(n next),
    %w(f finish),
    %w(w whereami),
    %w(u up),
    %w(d down),
    %w(b break),
    %w(ss show-source),
    ['sd', 'show-source -d'],
  ].each do |short, full|
    Pry.commands.alias_command short, full
  end
end
