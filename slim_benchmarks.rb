require 'benchmark/ips'
require 'tilt'
require 'erubis'
require 'erb'
require 'haml'
require 'slim'

module SlimBenchmarks
  def initialize
    @benches  = []
    @template = ENV['TEMPLATE'] || 'simple'

    context_path = "./views/#{@template}.rb"
    erb_path  = File.expand_path("./views/#{@template}.erb", __dir__)
    haml_path = File.expand_path("./views/#{@template}.haml", __dir__)
    slim_path = File.expand_path("./views/#{@template}.slim", __dir__)

    require_relative context_path
    @erb_code  = File.read(erb_path)
    @haml_code = File.read(haml_path)
    @slim_code = File.read(slim_path)
  end

  def run
    Benchmark.ips do |x|
      @benches.each do |name, block|
        x.report(name.to_s, &block)
      end
      x.compare!
    end
    explain_bench
  end

  private

  def bench(name, &block)
    @benches.push([name, block])
  end

  def explain_bench
    # override to notice about benchmark
  end
end
