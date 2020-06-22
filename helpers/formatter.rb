# frozen_string_literal: true

require_relative 'tty'

module Formatter
  module_function

  def url(string)
    "#{Tty.underline}#{string}#{Tty.no_underline}"
  end
end
