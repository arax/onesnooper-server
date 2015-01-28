[![Build Status](https://secure.travis-ci.org/arax/onesnooper-server.png)](http://travis-ci.org/arax/onesnooper-server)
[![Dependency Status](https://gemnasium.com/arax/onesnooper-server.png)](https://gemnasium.com/arax/onesnooper-server)
[![Gem Version](https://fury-badge.herokuapp.com/rb/onesnooper-server.png)](https://badge.fury.io/rb/onesnooper-server)
[![Code Climate](https://codeclimate.com/github/arax/onesnooper-server.png)](https://codeclimate.com/github/arax/onesnooper-server)

# ONESnooper Server
Simple server snooping on and recording OpenNebula's VM &amp; Host monitoring traffic.

## Requirements
* Ruby >= 1.9.3
* Rubygems
* Database (SQLite, MySQL, MongoDB)
* OpenNebula >= 4.10 (doesn't have to be present on the same machine)
* `iptables` with `TEE`

__Some dependencies require `dev` versions of various `lib` packages to compile native extensions.__

## Installation
```bash
gem install onesnooper-server
```

## Configuration
### UDP Datagram Mirroring
* OpenNebula Manager Host:
```bash
iptables -I PREROUTING -p udp -m udp --dport 4124 -j TEE --gateway $ONESNOOPER_HOST
```
* ONESnooper Server Host:
```bash
iptables -I PREROUTING -d $ONE_MANAGER_HOST/32 -p udp -m udp --dport 4124 -j DNAT --to-destination $ONESNOOPER_HOST:9000
```

### Database Configuration
__You can use multiple databases at the same time!__

You can choose from:
* SQLite3 (not recommended for production)
* MySQL
* MongoDB

For SQL-based databases, you can use this [Sequel migration script](https://raw.githubusercontent.com/arax/onesnooper-server/master/migrations/001_create_db.rb):
```bash
cd /tmp
mkdir migrations
cd migrations
wget https://raw.githubusercontent.com/arax/onesnooper-server/master/migrations/001_create_db.rb
cd ..
sequel -m migrations sqlite:///tmp/onesnooper-server.sqlite
```
__For MySQL, just adapt the DB location on the last line according to your local MySQL configuration and Sequel documentation.__

### ONESnooper Server Configuration
You can configure ONESnooper Server by saving an updated version of the following configuration
file as `/etc/onesnooper-server/onesnooper-server.yml`.

```yaml
---
defaults: &defaults
  bind_address: 127.0.0.1
  bind_port: 9000
  log_level: info
  store:
  - mongodb
  stores:
    sqlite:
      database_file: /tmp/onesnooper-server.sqlite
    mysql:
      database: one_monitoring
      host: localhost
      port: 3306
      username:
      password:
    mongodb:
      database: one_monitoring
      host: localhost
      port: 27017
  allowed_sources:
  - 127.0.0.1

###############################################
#######  DO NOT EDIT AFTER THIS POINT  ########
###############################################

production:
  <<: *defaults

development:
  <<: *defaults
  log_level: debug
  store:
  - sqlite

test:
  <<: *defaults
  log_level: debug
  store:
  - sqlite
```

## Usage
Start `onesnooper-server` and wait ...

## Code Documentation
[Code Documentation for OneacctExport by YARD](http://rubydoc.info/github/arax/onesnooper-server/)

## Continuous integration
[Continuous integration for OneacctExport by Travis-CI](http://travis-ci.org/arax/onesnooper-server/)

## Contributing
1. Fork it ( https://github.com/arax/onesnooper-server/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
