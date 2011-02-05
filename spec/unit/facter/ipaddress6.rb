#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../../spec_helper.rb'

require 'facter'

describe "IPv6 address fact" do

  after do
    Facter.clear
  end

  it "should return ipaddress6 information for Linux" do
    sample_output_file = File.dirname(__FILE__) + "/../../data/linux_ifconfig_all_with_multiple_interfaces"
    linux_ifconfig = File.new(sample_output_file).read
    Facter.fact(:kernel).stubs(:value).returns("Linux")
    Facter::Util::Resolution.expects(:exec).with("/sbin/ifconfig").returns(linux_ifconfig)
    Facter.value(:ipaddress6).should == "2001:06a8:1100:cafe:daa2:5eff:fe8e:7444"
  end

  it "should return ipaddress6 information for Solaris" do
    sample_output_file = File.dirname(__FILE__) + "/../../data/sunos_ifconfig_all_with_multiple_interfaces"
    sunos_ifconfig = File.new(sample_output_file).read
    Facter.fact(:kernel).stubs(:value).returns("SunOS")
    Facter::Util::Resolution.expects(:exec).with("/usr/sbin/ifconfig -a").returns(sunos_ifconfig)
    Facter.value(:ipaddress6).should == "2001:06a8:1100:cafe:daa2:5eff:fe8e:7444"
  end

  it "should return ipaddress6 information for Darwin" do
    sample_output_file = File.dirname(__FILE__) + "/../../data/darwin_ifconfig_all_with_multiple_interfaces"
    darwin_ifconfig = File.new(sample_output_file).read
    Facter.fact(:kernel).stubs(:value).returns("Darwin")
    Facter::Util::Resolution.expects(:exec).with("/usr/sbin/netstat -rn -f inet6").returns('')
    Facter::Util::Resolution.expects(:exec).with("/sbin/ifconfig -a").returns(darwin_ifconfig)
    Facter.value(:ipaddress6).should == "2001:06a8:1100:cafe:daa2:5eff:fe8e:7444"
  end

  it "should return ipaddress6 information for FreeBSD" do
    sample_output_file = File.dirname(__FILE__) + "/../../data/bsd_ifconfig_all_with_multiple_interfaces"
    freebsd_ifconfig = File.new(sample_output_file).read
    Facter.fact(:kernel).stubs(:value).returns("FreeBSD")
    Facter::Util::Resolution.expects(:exec).with("/usr/sbin/netstat -rn -f inet6").returns('')
    Facter::Util::Resolution.expects(:exec).with("/sbin/ifconfig -a").returns(freebsd_ifconfig)
    Facter.value(:ipaddress6).should == "2001:06a8:1100:cafe:daa2:5eff:fe8e:7444"
  end

end

