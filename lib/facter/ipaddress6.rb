# Cody Herriges <c.a.herriges@gmail.com>
#
# Used the ipaddress fact that is already part of
# Facter as a template.


# Uses ruby's own resolv class which queries DNS and /etc/hosts.
# The closest thing to a default/primary IPv6 addresses is
# assumed to be the AAAA that you have published via DNS or
# an /etc/host entry.
Facter.add(:ipaddress6, :timeout => 2) do
  setcode do
    require 'resolv'

    begin
      if fqdn = Facter.value(:fqdn)
        ip = nil
        Resolv.getaddresses(fqdn).each { |str|
          str = str.to_s
          if str =~ /(?>[0-9,a-f,A-F]*\:{1,2})+[0-9,a-f,A-F]{0,4}/ and str != "::1"
            ip = str
          end
        }

      ip

      else
        nil
      end
      rescue Resolv::ResolvError
        nil
      rescue NoMethodError # i think this is a bug in resolv.rb?
        nil
    end
  end
end

# Uses the OS' host command to do a DNS lookup.
Facter.add(:ipaddress6, :timeout => 2) do
  setcode do
  if fqdn = Facter.value(:fqdn)
    ip = nil
    host = nil
    if host = Facter::Util::Resolution.exec("host -t AAAA #{fqdn}")
      host.scan(/((?>[0-9,a-f,A-F]{0,4}\:{1,2})+[0-9,a-f,A-F]{0,4}&)/).each { |str|
      str = str.to_s
      unless str =~ /fe80.*/ or str == "::1"
       ip = str
      end
    }
    else
      nil
    end
    ip
  else
    nil
  end
  end
end

# OS dependant code that parses the output of various networking
# tools and currently not very intelligent. Returns the first
# non-loopback and non-linklocal address found in the ouput unless
# a default route can be mapped to a routeable interface. Guessing
# an interface is currently only possible with BSD type systems
# to many assumptions have to be made on other platforms to make
# this work with the current code. Most code ported or modeled
# after the ipaddress fact for the sake of similar functionality
# and familiar mechanics.
Facter.add(:ipaddress6) do
  confine :kernel => :linux
  setcode do
    ip = nil
    output = Facter::Util::Resolution.exec("/sbin/ifconfig")

    output.scan(/inet6 addr: ((?>[0-9,a-f,A-F]*\:{1,2})+[0-9,a-f,A-F]{0,4})/).each { |str|
      str = str.to_s
      unless str =~ /fe80.*/ or str == "::1"
        ip = str
      end
    }

    ip

  end
end

Facter.add(:ipaddress6) do
  confine :kernel => %w{SunOS}
  setcode do
    output = Facter::Util::Resolution.exec("/usr/sbin/ifconfig -a")
    ip = nil

    output.scan(/inet6 ((?>[0-9,a-f,A-F]*\:{0,2})+[0-9,a-f,A-F]{0,4})/).each { |str|
      str = str.to_s
      unless str =~ /fe80.*/ or str == "::1"
        ip = str
      end
    }

    ip

  end
end

Facter.add(:ipaddress6) do
  confine :kernel => %w{Darwin FreeBSD OpenBSD}
  setcode do
    interout = Facter::Util::Resolution.exec("/usr/sbin/netstat -rn -f inet6")
    interface = interout.scan(/^default\s+fe80\S+\s+[A-Z]+\s+\d\s+\d+\s+([a-z]+\d)/).to_s
    if interface != ''
      output = Facter::Util::Resolution.exec("/sbin/ifconfig #{interface}")
    else
      puts "Unable to find a default route interface, using first non-loopback address"
      output = Facter::Util::Resolution.exec("/sbin/ifconfig -a")
    end
    ip = nil

    output.scan(/inet6 ((?>[0-9,a-f,A-F]*\:{1,2})+[0-9,a-f,A-F]{0,4})/).each { |str|
      str = str.to_s
      unless str =~ /fe80.*/ or str == "::1"
        ip = str
      end
      }

      ip

  end
end

