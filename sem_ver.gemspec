Gem::Specification.new do |s|
  s.name        = 'sem_ver'
  s.version     = '0.1.1'
  s.date        = Date.today
  s.authors     = ['Sergio Gil']
  s.email       = ['sgilperez@gmail.com']
  s.homepage    = 'http://github.com/porras/sem_ver'
  s.summary     = 'Semantic Version parser'
  s.description = 'Semantic Version parser'

  s.files         = Dir['lib/**/*.rb'] + ['README.md']
  s.test_files    = Dir['spec/**/*.rb']
  
  s.require_paths = ['lib']
end
