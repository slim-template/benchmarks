#!/usr/bin/env ruby

require_relative './slim_benchmarks'

class ParsingBenchmarks
  include SlimBenchmarks

  def initialize
    super
    init_parsing_benches
  end

  def init_parsing_benches
    context = Context.new
    context_binding = context.instance_eval { binding }

    bench('(3) erb')         { ERB.new(@erb_code).result(context_binding) }
    bench('(3) erubis')      { Erubis::Eruby.new(@erb_code).result(context_binding) }
    bench('(3) fast erubis') { Erubis::FastEruby.new(@erb_code).result(context_binding) }
    bench('(3) temple erb')  { Temple::ERB::Template.new { @erb_code }.render(context) }
    bench('(3) slim pretty') { Slim::Template.new(pretty: true) { @slim_code }.render(context) }
    bench('(3) slim ugly')   { Slim::Template.new { @slim_code }.render(context) }
    bench('(3) haml pretty') { Haml::Engine.new(@haml_code, format: :html5, escape_attrs: false).render(context) }
    bench('(3) haml ugly')   { Haml::Engine.new(@haml_code, format: :html5, ugly: true, escape_attrs: false).render(context) }
  end

  private

  def explain_bench
    puts "
(3) Parsing benchmark. Template is parsed every time.
    This is not the recommended way to use the template engine
    and Slim is not optimized for it. Activate this benchmark with 'rake bench slow=1'.

Temple ERB is the ERB implementation using the Temple framework. It shows the
overhead added by the Temple framework compared to ERB.
"
  end
end

ParsingBenchmarks.new.run
