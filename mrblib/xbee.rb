#
# PlatoDevice::XBee class
#
module PlatoDevice
  class XBee < Plato::ZigBee
    include Plato
    CR = "\r"
    TMO_RESPONSE = 3000

    def initialize
      @xb = Plato::Serial.open(9600, 8, 1, 1, :none)
      @cr = CR
    end

    def self.open(pan=nil)
      xb = self.new
      xb.panid = pan if pan
      xb
    end

    def _read
      c = @xb._read
      c = -1 if c > 0xff
      c
    end

    def _write(c); @xb._write(c); end
    def available; @xb.available; end
    def flush; @xb.flush; end

    def close
      @xb.close if @xb
      @xb == nil
    end

    # Send AT command
    def at(cmd)
      self.puts cmd
    end

    # Wait for CR reception
    def wait_cr(tmo=nil)
      t = Machine.millis + tmo if tmo
      loop {
        rsp = self.gets
        return rsp.chomp if rsp.size > 0
        raise "XBee response timeout" if t && t <= Machine.millis
        Machine.delay(10)
      }
    end

    # Send AT command and receive response
    def at_cr(cmd, tmo=nil)
      at(cmd)
      wait_cr(tmo)
    end

    # Enter AT command mode
    def enter_at_mode
      while gets.size > 0; end  # discard remain data
      Machine.delay(1000) # wait 1 second
      loop {
        self.write '+'; Machine.delay(1)
        self.write '+'; Machine.delay(1)
        self.write '+'
        Machine.delay(1000) # wait 1 second
        rsp = self.gets
        return rsp if rsp == "OK\r"
      }
    end

    # Leave AT command mode
    def leave_at_mode
      at_cr('atcn', 1000)
    end

    # set PAN ID
    def panid=(id)
      id = id.to_s unless id.instance_of?(String)
      enter_at_mode
      at_cr('atid' + id, 3000)
      leave_at_mode
    end

    # get PAN ID
    def panid
      enter_at_mode
      id = at_cr('atid', 2000)
      leave_at_mode
      id
    end

    # get connected target addresses
    def connections
      targets = []
      enter_at_mode
      at('atnd')
      while true
        a = wait_cr       # XXXX
        break if a == ''
        adrh = wait_cr    # Address (H)
        adrl = wait_cr    # Address (L)
        targets << [adrh, adrl]
        6.times {wait_cr} # ' ', XXXX, XX, XX, XX, XXXX, XXXX
      end
      leave_at_mode
      targets
    end

    # connect
    def connect(adrh='0', adrl='ffff')
      enter_at_mode
      at_cr("atdh#{adrh}", 3000)
      at_cr("atdl#{adrl}", 3000)
      leave_at_mode
    end

    # get my address
    def my_address
      enter_at_mode
      addr = [at_cr('atsh', 2000), at_cr('atsl', 2000)]
      leave_at_mode
      addr
    end

    # reset network settings
    def reset
      enter_at_mode
      at_cr('atnr', 3000)
      leave_at_mode
    end

    # save settings
    def save
      enter_at_mode
      at_cr('atwr', 3000)
      leave_at_mode
    end

    def config(sw=nil)
      if sw
        bt = Plato::ButtonSwitch.new(sw)
        tmo = Machine.millis + 1000
        while tmo > Machine.millis
          if bt.on?
            XBeeConfig.new(self).menu
            break
          end
          Machine.delay(1)
        end
      end
      self
    end

    def atcmd(cmds, tmo=2000)
      cmds = [cmds] unless cmds.instance_of?(Array)
      rsp = []
      begin
        enter_at_mode
        cmds.each {|c|
          rsp << at_cr(c, tmo)
        }
        leave_at_mode
        rsp = rsp[0] if rsp.size == 1
      rescue
      end
      return rsp
    end

  end
end
