MRuby::Gem::Specification.new('mruby-plato-zigbee-xbee') do |spec|
  spec.license = 'MIT'
  spec.authors = 'Plato developers'
  spec.description = 'PlatoDevice::XBee class (XBee device class)'

  spec.add_dependency('mruby-string-ext')
  spec.add_dependency('mruby-plato-machine')
  spec.add_test_dependency('mruby-plato-machine-sim')
  spec.add_dependency('mruby-plato-serial')
  spec.add_dependency('mruby-plato-zigbee')
end
