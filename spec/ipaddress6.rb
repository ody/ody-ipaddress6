#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../../spec_helper'

require 'facter'

describe "IPv6 address fact" do

  it "should return ipaddress6 information for Solaris" do
    sample_output_file = File.dirname(__FILE__) + "/../data/sunos_ifconfig_all_with_multiple_interfaces"
    solaris_ifconfig = File.new(sample_output_file).read()


    Facter.value(:ipaddress6).should == "2610:10:20:209:203:baff:fe27:a7c"
  end
end
