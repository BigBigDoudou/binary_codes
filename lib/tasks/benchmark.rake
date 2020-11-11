# frozen_string_literal: true

require 'benchmark'

desc 'Benchmark'
task :benchmark do
  key_list = %w[alfa bravo charlie delta echo foxtrot golf]
  benchmark_encode(key_list)
  benchmark_decode(key_list)
  benchmark_union(key_list)
  benchmark_include(key_list)
end

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Style/DocumentationMethod
def benchmark_encode(key_list)
  encode = ->(elts) { elts.map { |elt| 1 << (key_list.index(elt)) }.sum }
  benchmark =
    Benchmark.measure do
      100_000.times { encode.call(%w[alfa charlie echo golf]) }
    end

  competitor = ->(elts) { elts.sort.join(';') }
  competitor_benchmark =
    Benchmark.measure do
      100_000.times { competitor.call(%w[alfa charlie echo golf]) }
    end

  puts '--- encoding ---'
  puts benchmark
  puts competitor_benchmark
  ratio = (benchmark.real - competitor_benchmark.real) / competitor_benchmark.real
  puts "  -> Encoding with binary takes #{ratio.round(2)} more time than the 'array to string' system"
end

def benchmark_decode(key_list)
  decode = ->(code) { key_list.select.with_index { |_, i| (code >> i).odd? } }

  benchmark =
    Benchmark.measure do
      100_000.times { decode.call(85) }
    end

  competitor = ->(string) { string.split(';') }
  competitor_benchmark =
    Benchmark.measure do
      100_000.times { competitor.call('alfa;charlie;echo;golf') }
    end

  puts '--- decoding ---'
  puts benchmark
  puts competitor_benchmark
  ratio = (benchmark.real - competitor_benchmark.real) / competitor_benchmark.real
  puts "  -> Decoding with binary takes #{ratio.round(2)} more time than the 'string to array' system"
end

def benchmark_union(key_list)
  decode = ->(code) { key_list.select.with_index { |_, i| (code >> i).odd? } }
  benchmark =
    Benchmark.measure do
      100_000.times { decode.call(85 | 35) }
    end

  competitor_benchmark =
    Benchmark.measure do
      100_000.times { ('alfa;charlie;echo;golf'.split(';') | 'alfa;bravo;foxtrot'.split(';')).sort }
    end

  puts '--- union ---'
  puts benchmark
  puts competitor_benchmark
  ratio = (benchmark.real - competitor_benchmark.real) / competitor_benchmark.real
  puts "  -> Union with binary takes #{ratio.round(2)} more time than with arrays"
end

def benchmark_include(key_list)
  encode = ->(elts) { elts.map { |elt| 1 << (key_list.index(elt)) }.sum }
  benchmark =
    Benchmark.measure do
      100_000.times { (85 & encode.call(['alfa'])).positive? }
    end

  competitor_benchmark =
    Benchmark.measure do
      100_000.times { ('alfa;charlie;echo;golf'.split(';') & ['alfa']).any? }
    end

  puts '--- include ---'
  puts benchmark
  puts competitor_benchmark
  ratio = (benchmark.real - competitor_benchmark.real) / competitor_benchmark.real
  puts "  -> Include with binary takes #{ratio.round(2)} more time than with arrays"
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Style/DocumentationMethod
