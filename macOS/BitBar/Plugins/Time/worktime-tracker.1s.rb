#!/usr/bin/env LC_ALL=en_US.UTF-8 ruby

# <bitbar.title>Worktime Tracker</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Ash Wu(hSATAC)</bitbar.author>
# <bitbar.author.github>hSATAC</bitbar.author.github>
# <bitbar.desc>A simple worktime tracker with record history.</bitbar.desc>
# <bitbar.dependencies>ruby</bitbar.dependencies>

# Functionality:
# * Start / stop / pause / resume the timing session.
# * Keep history records and export to a txt file.
# * Rename session.

require 'json'

### ASSETS ###

ICON_PLAY = "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"
ICON_PLAY_COLOR = "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"
ICON_PAUSE   = "iVBORw0KGgoAAAANSUhEUgAAACoAAAAqCAYAAADFw8lbAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAACXBIWXMAABYlAAAWJQFJUiTwAAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgpMwidZAAABuElEQVRYCe1XUUrEQAzd7ioIiifw3ysIHsRbeBE/BI8h+CseSP/0RxBEdlvfW+dJpkxtp0RQNoHsZJI3SfrapeliERIMBAPBQDCwEww0c66y67oVzpXObpqm6WxOYIkjvi8tsG3f6bZPhQfz2bi1SwfG4vZMiRUbz2wmJmOQCwTOoW9QMfYB+xrx59QAsS3sE/gvoWKaLB5CHxC/R3xJHPZ+gqTbW4j1DlqSU1ZDYEVN9lkJCN9Niu9xHZNJIJNErLwm3zvWJXQfSnY3UApxultr2PTTR6V9ACV+stQ2qsT6c/A8bTZFW81phev70aBNUYwXOFmqwANZxfJAOHPXYLODHo1mCX9rE416MxuMBqPeDHjn26lnVG8abxKzfB6Mzn7bZJ2MbDwaHSnhE/ZotObW12CzK5w7PWmc4wjHoZdjHm09BlzVFO3+mMe6VcNybaMqfoxCFM6VkiMYGv+EY4w15OeeF0XhlD9ZahsVC7eo8ATtf4q8pMrEqdlH2FdQsc3Y9lMEK0U5v3Zev/iEUAPFlDZu7RJ4LG7P/FjUAq2NAprqrZv23/lc7ncW+2AgGAgGgoH/wcAnzm2uPw9Tc7IAAAAASUVORK5CYII="

### HELPERS ###

def prompt(question, default)
    result = `/usr/bin/osascript -e 'Tell application "System Events" to display dialog "#{question}" default answer "#{default}"' -e 'text returned of result' 2>/dev/null`.strip
    result.empty? ? defult : result
end

def notification(msg, title)
  `/usr/bin/osascript -e 'display notification "#{msg}" with title "#{title}"'`
end

### CLASSES ###

class WorkSession
  attr_reader :start_time, :end_time, :pause_time, :resume_time, :saved_duration, :name, :state

  def initialize(name)
    @name = name
    @state = "stopped"
    @saved_duration = 0
  end

  def duration
    t = @saved_duration

    if @state != "paused"
      if @resume_time
        t += (Time.now - @resume_time)
      else
        t += (Time.now - @start_time)
      end
    end

    Time.at(t).utc.strftime("%H:%M:%S")
  end

  def start
    return if @state != "stopped"
    @state = "recording"
    @start_time = Time.now
  end

  def stop
    return if @state != "recording"
    @state = "stopped"
    @end_time = Time.now
  end

  def last_start_time
    @resume_time || @start_time
  end

  def pause
    return if @state != "recording"
    @state = "paused"
    @pause_time = Time.now
    @saved_duration += (@pause_time - last_start_time)
  end

  def resume
    return if @state != "paused"
    @state = "recording"
    @resume_time = Time.now
  end

  def rename(new_name)
    @name = new_name
  end

  def to_s
    "#{@name}, #{@start_time} ~ #{@end_time}, #{duration}"
  end
end

class WorkTimer
  attr_reader :workdir, :session

  def initialize(workdir = nil)
    @workdir = workdir || File.dirname(__FILE__)
    load_session
  end

  def session_file
    File.join @workdir, ".worktimer.dat"
  end

  def history_file
    File.join @workdir, "worktimer", "history.txt"
  end

  def state
    @session.nil? ? "stopped" : @session.state
  end

  def start
    session_name = prompt("Enter session name:", "Unnamed Session")
    @session = WorkSession.new session_name
    @session.start
    save_session

    notification("New session [#{@session.name}] has started.", "Worktime Tracker")
  end

  def stop
    @session.stop
    save_history
    delete_session

    notification("You spent #{duration} in [#{@session.name}]", "Worktime Tracker")
  end

  def pause
    @session.pause
    save_session

    notification("Session [#{@session.name}] has been paused.", "Worktime Tracker")
  end

  def resume
    @session.resume
    save_session

    notification("Session [#{@session.name}] has been resumed.", "Worktime Tracker")
  end

  def rename
    abort "Session does not exist." if @session.nil?
    session_name = prompt("Enter new session name:", @session.name)
    @session.rename session_name
    save_session

    notification("Current session renamed to: [#{@session.name}]", "Worktime Tracker")
  end

  def duration
    @session.nil? ? '' : @session.duration
  end

  def save_session
    File.open(session_file, 'w') {|f| f.write(Marshal.dump(@session)) }
  end

  def delete_session
    File.delete(session_file)
  end

  def load_session
    if File.exist? session_file
      @session = Marshal.load(File.read(session_file))
    end
  end

  def save_history
    system 'mkdir', '-p', File.dirname(history_file)
    File.open(history_file, 'a') { |f| f.write("#{session}\n") }
  end

  def history
    if File.exist? history_file
      system '/usr/bin/open', history_file
    else
      notification("History file not found.", "Worktime Tracker")
    end
  end
end

timer = WorkTimer.new

### ACTIONS ###

if ARGV[0]
  action = ARGV[0].to_sym
  if timer.respond_to? action
    timer.send(action)
    exit
  end
end

### RENDER ###

REFRESH = "---\nReload| refresh=true"


case timer.state
when "stopped"
  TITLE = "|templateImage=#{ICON_PLAY}"
  MENU = """
Start | bash='#{__FILE__}' param1=start terminal=false
"""
when "recording"
  TITLE = " #{timer.duration} | image=#{ICON_PLAY_COLOR}"
  MENU = """
#{timer.session.name} | bash='#{__FILE__}' param1=rename terminal=false
---
Pause | bash='#{__FILE__}' param1=pause terminal=false
Stop | bash='#{__FILE__}' param1=stop terminal=false
"""
when "paused"
  TITLE = "#{timer.duration} |templateImage=#{ICON_PAUSE}"
  MENU = """
#{timer.session.name} | bash='#{__FILE__}' param1=rename terminal=false
---
Resume | bash='#{__FILE__}' param1=resume terminal=false
"""
end

HISTORY = "History | bash='#{__FILE__}' param1=history terminal=false"

puts """
#{TITLE}
---
#{MENU}
---
#{HISTORY}
---
#{REFRESH}
"""
