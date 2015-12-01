#!/usr/bin/env ruby

require_relative './slim_benchmarks'

class TiltBenchmarks
  include SlimBenchmarks

  def init_erb_benches
    tilt_erb         = Tilt::ERBTemplate.new { @erb_code }
    tilt_erubis      = Tilt::ErubisTemplate.new { @erb_code }
    tilt_temple_erb  = Temple::ERB::Template.new { @erb_code }

    bench('erb')        { tilt_erb.render(context) }
    bench('erubis')     { tilt_erubis.render(context) }
    bench('temple erb') { tilt_temple_erb.render(context) }
  end

  def init_haml_benches
    options = { escape_attrs: escape_html?, escape_html: escape_html?, format: :html5 }
    tilt_haml_pretty = Tilt::HamlTemplate.new(options) { @haml_code }
    tilt_haml_ugly   = Tilt::HamlTemplate.new(options.merge(ugly: true)) { @haml_code }

    bench('haml pretty') { tilt_haml_pretty.render(context) }
    bench('haml ugly')   { tilt_haml_ugly.render(context) }
  end

  def init_slim_benches
    tilt_slim_pretty = Slim::Template.new(pretty: true) { @slim_code }
    tilt_slim_ugly   = Slim::Template.new { @slim_code }

    bench('slim pretty') { tilt_slim_pretty.render(context) }
    bench('slim ugly')   { tilt_slim_ugly.render(context) }
  end

  private

  def explain_bench
    puts "
Compiled Tilt benchmark. Template is compiled with Tilt, which gives a more
accurate result of the performance in production mode in frameworks like
Sinatra, Ramaze and Camping. (Rails still uses its own template
compilation.)

Temple ERB is the ERB implementation using the Temple framework. It shows the
overhead added by the Temple framework compared to ERB.
"
  end
end

TiltBenchmarks.new.run
