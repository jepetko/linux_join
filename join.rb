require 'optparse'
require 'pry'

class Join

  attr_accessor :options
  attr_accessor :file_a
  attr_accessor :file_b
  attr_accessor :result

  def initialize(options=[], ignored_options=[])
    parse options, ignored_options
    if options.length > 1
      self.file_a = options[options.length-2]
      self.file_b = options.last
    end
  end

  def join
    return if !(self.file_a && self.file_b)
    self.result = ''
    delimiter = options['-t'] || '\t'
    field_a = options['-1'] || '1'
    field_b = options['-2'] || '1'
    f_a = File.new(file_a, 'r')
    output = options['-o']
    while (file_a_line = f_a.gets)
      file_a_line_arr = file_a_line.split(delimiter)
      field_a_value = file_a_line_arr[field_a.to_i-1]
      f_b = File.new(file_b, 'r')
      while (file_b_line = f_b.gets)
        file_b_line_arr = file_b_line.split(delimiter)
        field_b_value = file_b_line_arr[field_b.to_i-1]
        if field_a_value == field_b_value
          self.result << (output ? output['1'].map {|idx| file_a_line_arr[idx.to_i-1] }.join(delimiter) : file_a_line.strip)
          self.result << delimiter
          self.result << (output ? output['2'].map {|idx| file_b_line_arr[idx.to_i-1] }.join(delimiter) : file_b_line)
          self.result << "\n" unless self.result.end_with?("\n")
        end
      end
      f_b.close
    end
    f_a.close
  end

  def self.main(ignored_options=[])
    instance = Join.new ARGV, ignored_options
    instance.join
    instance
  end

  private

  def parse(options=[], ignored_options=[])
    self.options = {}
    opts_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: ruby join.rb -t : -1 1 -2 2 file_a.txt -o 1.1 2.2 file_b.txt'
      opts.on('-1', '--1 join_field', String, 'join field') do |join_field|
        self.options['-1'] = join_field
      end
      opts.on('-2', '--2 join_field', String, 'join field') do |join_field|
        self.options['-2'] = join_field
      end
      opts.on('-o', '-o output', String, 'fields to be selected') do |output|
        files = {}
        output.split(/\s+/).each do |out|
          elements = out.split '.'
          file = elements.first
          fields = files[file]
          if !fields
            fields = []
            files[file] = fields
          end
          fields << elements.last if !fields.include?(elements.last)
        end
        self.options['-o'] = files
      end
      opts.on('-t', '-t delimiter', String, 'delimiter for file') do |delimiter|
        self.options['-t'] = delimiter
      end
      ignored_options.each { |ignored_opt| opts.on(ignored_opt, nil, '') {} }
    end
    opts_parser.parse! options
  end

end

join = Join.main
puts join.result
