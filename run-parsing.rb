#!/usr/bin/env ruby

require_relative './slim_benchmarks'

class ParsingBenchmarks
  include SlimBenchmarks

  def init_erb_benches
    bench('erb')         { ERB.new(@erb_code).result(context_binding) }
    bench('erubis')      { Erubis::Eruby.new(@erb_code).result(context_binding) }
    bench('fast erubis') { Erubis::FastEruby.new(@erb_code).result(context_binding) }
    bench('temple erb')  { Temple::ERB::Template.new { @erb_code }.render(context) }
  end

  def init_haml_benches
    bench('haml pretty') { Haml::Engine.new(@haml_code, format: :html5, escape_attrs: false).render(context) }
    bench('haml ugly')   { Haml::Engine.new(@haml_code, format: :html5, ugly: true, escape_attrs: false).render(context) }
  end

  def init_slim_benches
    bench('slim pretty') { Slim::Template.new(pretty: true) { @slim_code }.render(context) }
    bench('slim ugly')   { Slim::Template.new { @slim_code }.render(context) }
  end

  private

  def context_binding
    context.instance_eval { binding }
  end

  def explain_bench
    puts "
Parsing benchmark. Template is parsed every time.
This is not the recommended way to use the template engine
and Slim is not optimized for it. Activate this benchmark with 'rake bench slow=1'.

Temple ERB is the ERB implementation using the Temple framework. It shows the
overhead added by the Temple framework compared to ERB.
"
  end
end

ParsingBenchmarks.new.run
