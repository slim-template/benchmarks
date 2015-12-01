require 'benchmark/ips'
require 'tilt'
require 'erubis'
require 'erb'
require 'haml'
require 'hamlit'
require 'slim'

module SlimBenchmarks
  def initialize
    @benches  = []
    @template = ENV['TEMPLATE'] || 'simple'

    context_path = "./views/#{@template}.rb"
    if File.exist?(context_path)
      require_relative context_path
      @context = Context.new
    else
      @context = Object.new
    end

    erb_path = File.expand_path("./views/#{@template}.erb", __dir__)
    if File.exist?(erb_path)
      @erb_code = File.read(erb_path)
      init_erb_benches
    end

    haml_path = File.expand_path("./views/#{@template}.haml", __dir__)
    if File.exist?(haml_path)
      @haml_code = File.read(haml_path)
      init_haml_benches
    end

    slim_path = File.expand_path("./views/#{@template}.slim", __dir__)
    if File.exist?(slim_path)
      @slim_code = File.read(slim_path)
      init_slim_benches
    end
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

  def init_erb_benches
    # Initialize bench with @erb_code and @context
  end

  def init_haml_benches
    # Initialize bench with @haml_code and @context
  end

  def init_slim_benches
    # Initialize bench with @slim_code and @context
  end

  private

  attr_reader :context

  def bench(name, &block)
    @benches.push([name, block])
  end

  def explain_bench
    # override to notice about benchmark
  end

  def escape_html?
    ENV['ESCAPE'] == '1'
  end
end
