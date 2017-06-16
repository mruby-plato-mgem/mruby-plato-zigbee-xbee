# PlatoDevice::XBee class

class Ser
  include Plato::Serial
  attr_accessor :indata
  attr_reader :outdata
  def initialize(baud, dbits=8, start=1, stop=1, parity=:none)
    @indata = []
    @outdata = ''
  end
  def _read
    d = @indata.shift
    d.nil? ? -1 : d
  end
  def _write(v)
    @outdata << v.chr
  end
  def available; @indata.size; end
  def flush; @outdata = ''; end
  def close; end
end
class M
  def self.delay(ms); ms; end
  def self.delay_us(us); us; end
  def self.millis; 0; end
  def self.micros; 0; end
end
module PlatoDevice
  class XBee
    attr_reader :xb
  end
end

assert('XBee', 'class') do
  assert_equal(PlatoDevice::XBee.class, Class)
end

assert('XBee', 'superclass') do
  assert_equal(PlatoDevice::XBee.superclass, Plato::ZigBee)
end

assert('XBee', 'new') do
  assert_nothing_raised {
    Plato::Serial.register_device(Ser)
    PlatoDevice::XBee.new
  }
end

assert('XBee', 'open') do
  assert_nothing_raised {
    Plato::Serial.register_device(Ser)
    PlatoDevice::XBee.open
  }
end

assert('XBee', 'open - no device') do
  Plato::Serial.register_device(nil)
  assert_raise(RuntimeError) {PlatoDevice::XBee.open}
end

assert('XBee', '_read') do
  Plato::Serial.register_device(Ser)
  xb = PlatoDevice::XBee.open
  xb.xb.indata = [0, 1]
  assert_equal(xb._read, 0)
  assert_equal(xb._read, 1)
  assert_equal(xb._read, -1)
end

assert('XBee', '_write') do
  Plato::Serial.register_device(Ser)
  xb = PlatoDevice::XBee.open
  xb._write(0)
  xb._write(255)
  xb._write(1)
  assert_equal(xb.xb.outdata, "\0\377\1")
end

assert('XBee', 'flush') do
  assert_nothing_raised {
    Plato::Serial.register_device(Ser)
    xb = PlatoDevice::XBee.open
    xb.flush
  }
end

assert('XBee', 'close') do
  assert_nothing_raised {
    Plato::Serial.register_device(Ser)
    xb = PlatoDevice::XBee.open
    xb.close
  }
end
