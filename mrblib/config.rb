# XBee-WiFi configuration tool

class XBeeConfig
  def initialize(xb=nil)
    xb = PlatoDevice::XBee.new unless xb
    @xb = xb
  end

  # Show XBee configuration
  def show_config
    cfg = {}
    ca = [
      'ATID',   # PANID
      'ATDH',   # Destination Address (H)
      'ATDL'    # Destination Address (L)
    ]
    res = @xb.atcmd(ca)
    puts <<EOS
PANID:      #{res[0]}
Dest. Addr: [\"#{res[1]}\", \"#{res[2]}\"]
EOS
    puts "connections:  #{@xb.connections}"
  end

  # Configure ZigBee connection
  def configure_zigbee
    panid = input('PANID')
    adrh = input('Dest. Addr(H)')
    adrl = input('Dest. Addr(L)')
    @xb.reset
    @xb.panid = panid
    @xb.connect(adrh, adrl)
    @xb.save
  end

  def show_hard_info
    puts "<< XBee information >>"
    ca = [
      'ATHV',   # Hardware version
      'ATVR',   # Firmware version
      'ATSH',   # Address(H)
      'ATSL'    # Address(L)
    ]
    res = @xb.atcmd(ca)
    puts <<EOS
Hardware Version: 0x#{res[0].to_i.to_s(16)}
Firmware Version: 0x#{res[1].to_i.to_s(16)}
Adapter address:  #{[res[2].to_i.to_s(16), res[3].to_i.to_s(16)]}
EOS
  end

  def factory_reset
    if input_yn('Do you really want to reset XBee (y/N)', false)
      print "Factory reset in progress ... "
      @xb.atcmd ['ATRE', 'ATWR']
      puts "done."
    end
  end

  def menu
    loop {
      puts <<EOS
<< XBee configuration tool >>
S: Show network configuration
Z: ZigBee setting
H: XBee Hardware information
F: Factory reset
Q: Quit menu
EOS
      case input.strip.downcase
      when 's'; show_config
      when 'z'; configure_zigbee
      when 'h'; show_hard_info
      when 'f'; factory_reset
      when 'q'; break
      end
    }
  end

  # private

  # # input Y/N
  # def input_yn(prompt, default=true)
  #   ans = nil
  #   while ans.nil?
  #     print prompt, ' => '
  #     case gets.chomp.strip.downcase
  #     when '';  ans = default
  #     when 'y'; ans = true
  #     when 'n'; ans = false
  #     end
  #   end
  #   ans
  # end

  # input string
  def input(prompt='', accept_empty=false)
    inp = nil
    while inp.nil?
      print prompt, ' => '
      inp = gets.chomp.strip
      inp = nil if inp.size == 0 && !accept_empty
    end
    inp
  end
end
