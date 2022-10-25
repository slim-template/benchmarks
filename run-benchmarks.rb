#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'), File.dirname(__FILE__))

require 'slim'
require 'context'

require 'benchmark/ips'
require 'tilt'
require 'erubis'
require 'erb'
require 'haml'

class SlimBenchmarks
  def initialize
    @benches = []

    @erb_code  = File.read(File.dirname(__FILE__) + '/view.erb')
    @haml_code = File.read(File.dirname(__FILE__) + '/view.haml')
    @slim_code = File.read(File.dirname(__FILE__) + '/view.slim')

    init_compiled_benches
  end

  def init_compiled_benches
    haml = Haml::Engine.new(@haml_code, format: :html5, escape_attrs: false)

    context  = Context.new

    haml.def_method(context, :run_haml)
    context.instance_eval %{
      def run_erb; #{ERB.new(@erb_code).src}; end
      def run_temple_erb; #{Temple::ERB::Engine.new.call(@erb_code)}; end
      def run_erubis; #{Erubis::FastEruby.new(@erb_code).src}; end
      def run_slim; #{Slim::Engine.new.call(@slim_code)}; end
    }

    bench(:compiled, "erb #{ERB.version}")            { context.run_erb }
    bench(:compiled, "erubis #{Erubis::VERSION}")     { context.run_erubis }
    bench(:compiled, "temple erb #{Temple::VERSION}") { context.run_temple_erb }
    bench(:compiled, "slim #{Slim::VERSION}")         { context.run_slim }
    bench(:compiled, "haml #{Haml::VERSION}")         { context.run_haml }
  end

  def run
    Benchmark.ips do |x|
      @benches.each do |name, block|
        x.report(name.to_s, &block)
      end
      x.compare!
    end
  end

  def bench(group, name, &block)
    @benches.push([name, block])
  end
end

SlimBenchmarks.new.run
