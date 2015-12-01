#!/usr/bin/env ruby

require_relative './slim_benchmarks'

class CompiledBenchmarks
  include SlimBenchmarks

  def init_erb_benches
    init_erb_without_escape unless escape_html?

    context.instance_eval %{
      def run_erubis; #{Erubis::Eruby.new(@erb_code).src}; end
      def run_fast_erubis; #{Erubis::FastEruby.new(@erb_code).src}; end
    }

    bench('erubis')      { context.run_erubis }
    bench('fast erubis') { context.run_fast_erubis }
  end

  # These engines don't support unescaping by `==`
  def init_erb_without_escape
    context.instance_eval %{
      def run_erb; #{ERB.new(@erb_code).src}; end
      def run_temple_erb; #{Temple::ERB::Engine.new.call @erb_code}; end
    }
    bench('erb') { context.run_erb }
    bench('temple erb')  { context.run_temple_erb }
  end

  def init_haml_benches
    options = { escape_attrs: escape_html?, escape_html: escape_html?, format: :html5 }
    haml_pretty = Haml::Engine.new(@haml_code, options)
    haml_ugly   = Haml::Engine.new(@haml_code, options.merge(ugly: true))
    haml_pretty.def_method(context, :run_haml_pretty)
    haml_ugly.def_method(context, :run_haml_ugly)
    context.instance_eval %{
      def run_hamlit; #{Hamlit::Engine.new(options).call @haml_code}; end
    }

    bench('haml pretty') { context.run_haml_pretty }
    bench('haml ugly')   { context.run_haml_ugly }
    bench('hamlit')      { context.run_hamlit }
  end

  def init_slim_benches
    context.instance_eval %{
      def run_slim_pretty; #{Slim::Engine.new(pretty: true).call @slim_code}; end
      def run_slim_ugly; #{Slim::Engine.new.call @slim_code}; end
    }

    bench('slim pretty') { context.run_slim_pretty }
    bench('slim ugly')   { context.run_slim_ugly }
  end

  private

  def explain_bench
    puts "
Compiled benchmark. Template is parsed before the benchmark and
generated ruby code is compiled into a method.
This is the fastest evaluation strategy because it benchmarks
pure execution speed of the generated ruby code.

Temple ERB is the ERB implementation using the Temple framework. It shows the
overhead added by the Temple framework compared to ERB.
"
  end
end

CompiledBenchmarks.new.run
