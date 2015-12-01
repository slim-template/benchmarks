require 'rake/testtask'

desc 'Run Slim benchmarks!'
task :bench do
  mode = ENV['MODE'] || 'compiled'
  ruby("run-#{mode}.rb")
end

task default: 'bench'
