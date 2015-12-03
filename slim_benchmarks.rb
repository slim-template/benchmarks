require 'benchmark/ips'
require 'tilt'
require 'erubis'
require 'erb'
require 'haml'
require 'slim'

if /^ruby/ =~ RUBY_DESCRIPTION
  require 'hamlit'
end

module SlimBenchmarks
  def initialize
    @benches  = []
    @template = ENV['TEMPLATE'] || 'simple'

    @context    = load_context(@template)
    (@erb_code  = load_template(@template, 'erb'))  && init_erb_benches
    (@haml_code = load_template(@template, 'haml')) && init_haml_benches
    (@slim_code = load_template(@template, 'slim')) && init_slim_benches
    init_mri_benches if on_mri?
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

  def init_mri_benches
    # Initialize some benches for only MRI
  end

  private

  attr_reader :context

  def load_template(template, ext)
    path = File.expand_path("../views/#{template}.#{ext}", __FILE__)
    File.exist?(path) && File.read(path)
  end

  def load_context(template)
    Object.new.tap do |context|
      context_path = "./views/#{template}.rb"
      context.instance_eval(File.read(context_path)) if File.exist?(context_path)
    end
  end

  def bench(name, &block)
    @benches.push([name, block])
  end

  def explain_bench
    # override to notice about benchmark
  end

  def escape_html?
    ENV['ESCAPE'] == '1'
  end

  def on_mri?
    /^ruby/ =~ RUBY_DESCRIPTION
  end
end
