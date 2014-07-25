class BenchWarmer
  require 'benchmark'

  ITERATION = 50_000_000

  def self.string_length (test, string)
    test.report("#{string.length + 1} characters" ) do
      ITERATION.times do
        string + 'x'
      end
    end
  end

  def self.string_length_test
    Benchmark.bm(40) do |benchmark|
      string_length(benchmark, "12345678901234567890")
      string_length(benchmark, "123456789012345678901")
      string_length(benchmark, "1234567890123456789012")
      string_length(benchmark, "12345678901234567890123")
      string_length(benchmark, "123456789012345678901234")
      string_length(benchmark, "1234567890123456789012345")
      string_length(benchmark, "12345678901234567890123456")
    end
  end

  def self.symbol_vs_string_test
    Benchmark.bm(40) do |test|
      test.report('Instantiate Single String') { ITERATION.times { 'test_me' } }
      test.report('Instantiate Symbol') { ITERATION.times { :test_me } }
    end
  end
end
