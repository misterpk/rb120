require 'tty-screen'

class Banner
  CORNER = "+"
  DASH = "-"
  BLANK = " "
  SIDE = "|"

  def initialize(message, banner_width = message.size)
    @message = message
    @banner_width = if banner_width > TTY::Screen.width
                      @message.size
                    elsif banner_width >= @message.size
                      banner_width
                    else
                      @message.size
                    end
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule]
      .join("\n")
  end

  private

  def horizontal_rule
    "#{CORNER} #{DASH * whitespace} #{CORNER}"
  end

  def empty_line
    "#{SIDE} #{BLANK * whitespace} #{SIDE}"
  end

  def message_line
    "#{SIDE} #{@message.center(whitespace)} #{SIDE}"
  end

  def whitespace
    @banner_width ? @banner_width : @message.size
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner

banner = Banner.new('')
puts banner

banner = Banner.new("hello", 100)
puts banner

banner = Banner.new("hello", 2)
puts banner

banner = Banner.new("hello", 700)
puts banner
