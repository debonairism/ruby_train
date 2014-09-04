#!/usr/bin/env ruby

class ParseLogFile

  require 'mime/types'
  require 'terminal-table'

  def initialize(location, type = 'text/plain')
    if file_present?(location) && correct_type?(location, type)
      open_log_file(location)
      format_rows
      output_table
    else
      puts 'File is not present' unless file_present?(location)
      puts 'File is not the correct type' unless correct_type?(location, type)
    end

  end

  def output_table
    table_output('Log File', headers, output)
  end

  def open_log_file(location)
    @file = File.open(location).read
  end

  def file_present?(location)
    File.file?(location)
  end

  def correct_type?(location, type)
    MIME::Types.type_for(location).first.content_type == type rescue false
  end

  def headers(add_headers = false)
    add_headers ? @formatted_rows.first : %w(Date Time Type Message)
  end

  def rows
    @file.split(/\r\n/)
  end

  def format_rows(separation = ' ', limit = 4)
    @formatted_rows = []
    @formatted_rows = rows.map do |row|
      row.split("#{separation}", limit)
    end
  end

  def table_output(title, header, row)
    table = Terminal::Table.new title: title,
                                headings: header,
                                rows: row
    table.style = {             border_x: '-',
                                border_i: '+',
                                padding_left: 1,
                                padding_right: 1}
    puts table
  end

  def output
    @formatted_rows.map do |row|
      row.map do |test|
        word_wrap(test, 70)
      end
    end
  end

  def word_wrap (text, number)
    words = text.split(' ' && '.')
    str = words.shift
    words.each do |word|
      connection = (str.size - str.rindex("\n").to_i + word.size > number) ? "\n" : ' '
      str += connection + word
    end
    str
  end

end
ParseLogFile.new( File.dirname(__FILE__) + '/log_file_example.txt', 'text/plain')

#location = '/Users/josephlee/Desktop/TR/parse_log_file/log_file_example.txt'