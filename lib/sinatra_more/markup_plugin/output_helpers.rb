module SinatraMore
  module OutputHelpers
    # Captures the html from a block of template code for erb or haml
    # capture_html(&block) => "...html..."
    def capture_html(*args, &block)
      if is_haml?
         block_is_haml?(block) ? capture_haml(*args, &block) : block.call
      else
        capture_erb(*args, &block)
      end
    end
    
    # Outputs the given text to the templates buffer directly
    # concat_content("This will be output to the template buffer in erb or haml")
    def concat_content(text="")
      if is_haml?
        haml_concat(text)
      else
        @_out_buf << text
      end
    end

    # Used to capture the html from a block of erb code
    # capture_erb(&block) => '...html...'
    def capture_erb(*args, &block)
      erb_with_output_buffer { block.call(*args) }
    end

    # Used to direct the buffer for the erb capture
    def erb_with_output_buffer(buf = '') #:nodoc:
      @_out_buf, old_buffer = buf, @_out_buf
      yield
      @_out_buf
    ensure
      @_out_buf = old_buffer
    end
  end
end
