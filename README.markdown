Module for reporting IPv6 addresses
===================================

ipaddress6.rb
-------------

Generates the standalone ipaddress6 fact. Supports the platforms I had access to for testing; Linux, Solaris, FreeBSD, OpenBSD, and OS X.  The idea here was not to rewrite the ipaddress fact but build on familiar code and concepts.

If the fact can detect a relationship between the inet6 default route and an interface with a valid inet6 address it will return this address, else it returns the fist valid address that is parsed out of ifconfig.

interfaces.rb
-------------

Have to include this even though it is included in the facter distribution because it needs a one line patch to include the creation of ipaddress6 interface facts.

util/ip.rb
----------

Needs to be patched from the standard facter distribution because the ipaddress6 regex has to be added to the supported platforms I have tested.

Installation
------------

* Puppet agents need pluginsync enabled in the puppet.conf: _pluginsync = true_
* Run puppet-module tool and install module to your modulepath: _puppet-module install ody-ipaddress6_
* Rename ody-ipaddress6: _mv ody-ipaddress6 ipaddress6_

Notes
-----

There are still a few bugs/inconsistencies related to interfaces.rb and util/ip.rb across various platforms.  These issues are present in those shipped with facter as well so once I work them out here I will submit patches to the facter project.
