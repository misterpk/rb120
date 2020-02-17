require 'tty-screen'

class Banner
  CORNER = "+"
  DASH = "-"
  BLANK = " "
  SIDE = "|"

  def initialize(message, banner_width = nil)
    @message = message
    if banner_width && banner_width < @message.size
      raise ArgumentError, "width provided is smaller than width of message"
    elsif banner_width && banner_width > TTY::Screen.width
      raise ArgumentError, "banner width larger than screen width"
    elsif banner_width
      @banner_width = banner_width
    else
      @banner_width = nil
    end
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule]
      .join("\n")
  end

  private

  def horizontal_rule
    if @banner_width
      "#{CORNER}#{DASH * whitespace}#{CORNER}"
    else
      "#{CORNER} #{DASH * whitespace} #{CORNER}"
    end
  end

  def empty_line
    if @banner_width
      "#{SIDE}#{BLANK * whitespace}#{SIDE}"
    else
      "#{SIDE} #{BLANK * whitespace} #{SIDE}"
    end
  end

  def message_line
    if @banner_width
      "#{SIDE}#{@message.center(whitespace)}#{SIDE}"
    else
      "#{SIDE} #{@message} #{SIDE}"
    end
  end

  def whitespace
    @banner_width ? @banner_width - 2 : @message.size
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner

banner = Banner.new('')
puts banner

banner = Banner.new("hello", 100)
puts banner

# banner = Banner.new("hello", 2)
# puts banner

# banner = Banner.new("hello", 700)
# puts banner
