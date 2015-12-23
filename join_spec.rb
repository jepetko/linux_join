require_relative 'join.rb'
require 'rspec'
require 'pry'

describe 'join' do

  let(:ignored_options) { %w{--require --example --format} }

  it 'supports the -1 option (join field of the first file)' do
    ARGV << '-1'
    ARGV << '3'
    join = Join.main ignored_options
    expect(join.options.keys).to include '-1'
    expect(join.options['-1']).to eq '3'
  end

  it 'supports the -2 option (join field of the second file)' do
    ARGV << '-2'
    ARGV << '3'
    join = Join.main ignored_options
    expect(join.options.keys).to include '-2'
    expect(join.options['-2']).to eq '3'
  end

  it 'supports the -o option (output)' do
    ARGV << '-o'
    ARGV << '1.1 1.2 2.1'
    join = Join.main ignored_options
    expect(join.options.keys).to include '-o'
    expect(join.options['-o']).to eq({'1' => %w{1 2}, '2' => ['1']})
  end

  it 'supports the -t option (delimiter)' do
    ARGV << '-t'
    ARGV << ','
    join = Join.main ignored_options
    expect(join.options.keys).to include '-t'
    expect(join.options['-t']).to eq ','
  end

  it 'uses the first field by default' do
    ARGV << '-t'
    ARGV << ':'
    ARGV << 'a.txt'
    ARGV << 'b.txt'
    join = Join.main ignored_options
    result = <<-RESULT.lstrip
root:x:0::root:x:0:0:root:/root:/bin/bash
katarina:x:1000::katarina:x:1000:1000:Katarina Golbang,,,:/home/katarina:/bin/bash
RESULT
    expect(join.result).to eq result
  end

  it 'selects the defined fields' do
    ARGV << '-t'
    ARGV << ':'
    ARGV << '-1'
    ARGV << '3'
    ARGV << '-2'
    ARGV << '3'
    ARGV << '-o'
    ARGV << '1.1 2.1 2.7'
    ARGV << 'a.txt'
    ARGV << 'b.txt'
    join = Join.main ignored_options
    result = <<-RESULT.lstrip
root:root:/bin/bash
avahi-autoipd:sshd:/usr/sbin/nologin
katarina:katarina:/bin/bash
    RESULT
    expect(join.result).to eq result
  end
end