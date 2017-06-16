# mruby-plato-zigbee-xbee   [![Build Status](https://travis-ci.org/mruby-plato/mruby-plato-zigbee-xbee.svg?branch=master)](https://travis-ci.org/mruby-plato/mruby-plato-zigbee-xbee)
PlatoDevice::XBee class (XBee device class)
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

  # ... (snip) ...

  conf.gem :git => 'https://github.com/mruby-plato/mruby-plato-serial'
  conf.gem :git => 'https://github.com/mruby-plato/mruby-plato-zigbee'
  conf.gem :git => 'https://github.com/mruby-plato/mruby-plato-xbee'
end
```

## example
```ruby
io = Plato::GPIO.new(0)
io.high
```

## License
under the MIT License:
- see LICENSE file
