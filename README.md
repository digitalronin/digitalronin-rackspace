A tool to manage Rackspace Cloud servers and Block Storage volumes

[![Gem Version](https://badge.fury.io/rb/digitalronin-rackspace.svg)](http://badge.fury.io/rb/digitalronin-rackspace)
[![Build Status](https://travis-ci.org/digitalronin/digitalronin-rackspace.svg?branch=master)](https://travis-ci.org/digitalronin/digitalronin-rackspace)
[![Dependency Status](https://gemnasium.com/digitalronin/digitalronin-rackspace.svg)](https://gemnasium.com/digitalronin/digitalronin-rackspace)

[fog](http://fog.io) is awesome, but the API can be a bit cryptic and long-winded, especially for things like creating a VM with an attached block storage volume

USAGE

Create an 8G General Purpose VM with an attached 75G SATA block storage volume;

    vm = Rackspace::Vm.new(
      size:     8,
      account:  'myaccount',
      name:     'testserver',
      volume:   { size: 75 }
    ).create

Destroy a VM and its attached storage volume

    Rackspace::Vm.new(account: 'myaccount', name: 'testserver').destroy(destroy_volume: true)

See the scripts in the examples directory

ASSUMPTIONS/PRE-REQUISITES

* Ruby 2.2.0 (1.9+ should work, but I haven't tested any versions except 2.2)
* Valid Rackspace Cloud account and API key (see rackspace_credentials.yml.example for how to supply these via a YAML file)
* By default, VMs are "General Purpose" Ubuntu 14.04 machines - this can be overridden by supplying "image_name" and "flavor_id"

CAVEATS

* This gem will create and destroy cloud servers and block storage volumes in your account. This could cost you money and might destroy data you care about. Use it with caution and at your own risk.

* The gem doesn't support attaching multiple volumes to a server.

* Deleting server with an attached volume can fail if the call to destroy the volume happens before it has finished detaching.

TODO

* The gem should wait to ensure success of any API operations before returning from the relevant method call

