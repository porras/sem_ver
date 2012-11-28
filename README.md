# SemVer [![Build Status](https://secure.travis-ci.org/porras/sem_ver.png?branch=master)](http://travis-ci.org/porras/sem_ver)

SemVer is a very simple [semantic version](http://semver.org/spec/v1.0.0.html) parser in Ruby. It takes a string and returns an object that can be validated and compared.

## Examples

    require 'sem_ver'
    
    SemVer.parse('0.0.10').valid?                       # true
    SemVer.parse('v1.0.10').valid?                      # true
    SemVer.parse('X.10').valid?                         # false
    
    SemVer.parse('1.0.0') >  SemVer.parse('0.9.9')      # true
    SemVer.parse('1.0.1') >= SemVer.parse('1.0.0')      # true
    SemVer.parse('1.0.1') >= SemVer.parse('1.1.0')      # false
    SemVer.parse('1.0.0') == SemVer.parse('1.0.0-pre1') # false
    SemVer.parse('1.0.0') >  SemVer.parse('1.0.0-pre1') # true
    
    ...

## Alternatives

If you need more advanced things, [versionomy](http://dazuma.github.com/versionomy/) looks great.

## Credits

Copyright © 2012 Sergio Gil, released under the MIT license
