# frozen_string_literal: true

class CodeSpitter
  module MemorySegments
    SEGMENT_TO_BASE_ADDRESS_LABEL = {
      'local' => 'LCL',
      'argument' => 'ARG',
      'this' => 'THIS',
      'that' => 'THAT',
      'temp' => '5'
    }.freeze

    CONSTANT = 'constant'
    POINTER = 'pointer'
    STATIC = 'static'

    module_function

    def segment_to_base_address_label(segment_name)
      SEGMENT_TO_BASE_ADDRESS_LABEL.fetch(segment_name)
    end

    def pointer_toggle_to_segment(toggle)
      toggle == '0' ? 'THIS' : 'THAT'
    end

    def build_static_var_name(file_name, step_from_base)
      without_ext = file_name.sub(/\..*\z/, '')
      first_letter = without_ext[0]

      "#{first_letter.upcase}#{without_ext[1..-1]}.#{step_from_base}"
    end
  end
end
