module PdfExtract

  module TextRuns

    def self.compute_x state
      # TODO Apply CTM and text matrix.
      # TODO units of :rise?
      state[:x] + state[:rise]
    end

    def self.compute_y state
      # TODO Apply CTM and text matrix.
      # TODO units of :leading?
      state[:y] + state[:leading]
    end

    def self.include_in pdf
      pdf.spatials :text_runs do |parser|
        clean_state = {
          :x => 0,
          :y => 0,
          :width => 0,
          :height => 0,
          :horizontal_scale => 1,
          :char_spacing => 0,
          :word_spacing => 0,
          :leading => 0,
          :rise => 0,
          :a => 1,
          :b => 0,
          :c => 0,
          :d => 1,
          :e => 0,
          :f => 0
        }
        global_state = clean_state.dup
        state = global_state

        parser.for :begin_page do |data|
          # TODO Handle UserUnits if set by page.
          global_state = clean_state.dup
          nil
        end

        parser.for :begin_text_object do |data|
          state = global_state.dup
          nil
        end

        parser.for :end_text_object do |data|
          # When not defining a text object, text operators alter a
          # global state.
          state = global_state
          nil
        end

        parser.for :set_text_leading do |data|
          state[:leading] = data
          nil
        end

        parser.for :set_text_rise do |data|
          state[:rise] = data
          nil
        end

        parser.for :set_character_spacing do |data|
          state[:char_spacing] = data
          nil
        end

        parser.for :set_word_spacing do |data|
          state[:word_spacing] = data
          nil
        end

        parser.for :set_horizontal_text_scaling do |data|
          state[:horizontal_scale] = (data.to_f / 100) + 1
          nil
        end

        parser.for :set_text_matrix_and_text_line_matrix do |data|
          # --     --
          # | a b 0 |
          # | c d 0 |
          # | e f 1 |
          # --     --
          #
          # Other operators modify this matrix to create a text-space
          # to device-space matrix (once muled with the CTM - current
          # transformation matrix).
          # 
          
          state[:a] = data[0]
          state[:b] = data[1]
          state[:c] = data[2]
          state[:d] = data[3]
          state[:e] = data[4]
          state[:f] = data[5]
          nil
        end

        parser.for :set_text_font_and_size do |data|
          # TODO Examine font ref, in data[0], for width
          # (combine with word spacing, char spacing callback data).

          # TODO Font is defined with height of 1 unit, which is
          # mul by data[1] to get height. However, UserUnit may
          # be specified in the page dictionary, which again should
          # be muled with height, possibly also width.

          # handle writing mode for composite fonts - select
          # one of two sets of font metrics.

          # If glyph displacement vectors are available, 
          # glyph displacement vector needs to be used in conjuction with
          # font height and glyph bounding box / glyph width to determine
          # extent of the run.
          
          # for all but type 3 font, divide all glyph metrics by 1000, for
          # type 3 apply the fontmatrix.

          # Handle type 3 font operators.

          state[:height] = data[1]
          nil
        end

        parser.for :show_text do |data|
          so = SpatialObject.new
          so[:x] = compute_x state
          so[:y] = compute_y state
          so[:width] = 0 # TODO sum_char_widths state, data
          so[:height] = state[:height]
          so[:content] = data.first
          so
        end
        
        parser.for :show_text_with_positioning do |data|
          data = data.first # TODO Handle elsewhere.
          
          offset = 0.0
          runs = []
          
          data.each do |text_or_offset|
            #puts text_or_offset.class
            case text_or_offset.class.to_s
            when "Fixnum"
              offset -= text_or_offset / 1000.0
            when "String"
              so = SpatialObject.new
              so[:x] = compute_x(state) + offset
              so[:y] = compute_y state
              so[:width] = 0 # TODO sum_char_widths state, data
              so[:height] = state[:height]
              so[:content] = text_or_offset
              runs << so
            end
          end

          runs
        end

        parser.for :move_text_position do |data|
          state[:x] += data[0]
          state[:y] += data[1]
          nil
        end

        parser.for :move_text_position_and_set_leading do |data|
          state[:x] += data[0]
          state[:y] += data[1]
          state[:leading] = data[2]
          nil
        end

        # TODO According to pdf-reader example, need to handle:
        # :show_text_with_positioning
        # :show_text
        # :super_show_text
        # :move_to_next_line_and_show_text
        # :set_spacing_next_line_show_text
        
        # TODO Add state modifiers for other text positioning
        # callbacks.
      end
    end

    private

    

  end

end
