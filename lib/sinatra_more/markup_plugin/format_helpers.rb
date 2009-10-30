module SinatraMore
  module FormatHelpers

    # Returns escaped text to protect against malicious content
    def escape_html(text)
      Rack::Utils.escape_html(text)
    end
    alias h escape_html
    alias sanitize_html escape_html

    # Returns escaped text to protect against malicious content
    # Returns blank if the text is empty
    def h!(text, blank_text = '&nbsp;')
      return blank_text if text.nil? || text.empty?
      h text
    end

    # Returns relative time in words referencing the given date
    # relative_time_ago(Time.now)
    def relative_time_ago(date)
      date = date.to_date
      date = Date.parse(date, true) unless /Date.*/ =~ date.class.to_s
      days = (date - Date.today).to_i

      return 'today'     if days >= 0 and days < 1
      return 'tomorrow'  if days >= 1 and days < 2
      return 'yesterday' if days >= -1 and days < 0

      return "in #{days} days"      if days.abs < 60 and days > 0
      return "#{days.abs} days ago" if days.abs < 60 and days < 0

      return date.strftime('%A, %B %e') if days.abs < 182
      return date.strftime('%A, %B %e, %Y')
    end

    # Used in xxxx.js.erb files to escape html so that it can be passed to javascript from sinatra
    # escape_javascript("<h1>Hey</h1>")
    def escape_javascript(html_content)
      return '' unless html_content
      javascript_mapping = { '\\' => '\\\\', '</' => '<\/', "\r\n" => '\n', "\n" => '\n' }
      javascript_mapping.merge("\r" => '\n', '"' => '\\"', "'" => "\\'")
      escaped_string = html_content.gsub(/(\\|<\/|\r\n|[\n\r"'])/) { javascript_mapping[$1] }
      "\"#{escaped_string}\""
    end

    alias js_escape escape_javascript
    alias js_escape_html escape_javascript
    alias escape_for_javascript escape_javascript

  end
end
