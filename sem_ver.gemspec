# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = 'sem_ver'
  spec.version     = '0.2.0'
  spec.authors     = ['Sergio Gil']
  spec.email       = ['sgilperez@gmail.com']
  spec.homepage    = 'http://github.com/porras/sem_ver'
  spec.summary     = 'Semantic Version parser'
  spec.description = 'Semantic Version parser'

  spec.files         = Dir['lib/**/*.rb'] + ['README.md']
  spec.test_files    = Dir['spec/**/*.rb']

  spec.require_paths = ['lib']

  spec.add_development_dependency('bundler', '~> 1.3')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rake')
end
