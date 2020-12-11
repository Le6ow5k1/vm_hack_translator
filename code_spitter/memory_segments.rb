# frozen_string_literal: true

class CodeSpitter
  module MemorySegments
    SEGMENT_TO_BASE_ADDRESS_LABEL = {
      'local' => 'LCL',
      'argument' => 'ARG',
      'this' => 'THIS',
      'that' => 'THAT'
    }.freeze

    module_function

    def segment_to_base_address_label(segment_name)
      SEGMENT_TO_BASE_ADDRESS_LABEL.fetch(segment_name)
    end
  end
end
