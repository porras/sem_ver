class SemVer
  class InvalidVersion < Exception; end
  
  include Comparable
  
  def self.parse(*args)
    new(*args)
  end
  
  def initialize(spec)
    @spec = spec
  end
  
  def major
    match && match[1].to_i
  end
  
  def minor
    match && match[2].to_i
  end
  
  def patch
    match && match[3].to_i
  end
  
  def prerelease
    match && match[5]
  end
  
  def valid?
    !!match
  end
  
  def <=>(other)
    raise InvalidVersion.new(to_s) unless valid? && other.valid?
    parts <=> other.parts
  end
  
  def to_s
    return @spec unless valid?
    "#{major}.#{minor}.#{patch}".tap do |v|
      v << "-#{prerelease}" if prerelease
    end
  end
  
  def inspect
    "<#{'Invalid' unless valid?}Version: #{to_s}>"
  end
  
  protected
  
  def parts
    [major, minor, patch, prerelease_value]
  end
  
  private
  
  def prerelease_value
    prerelease ? prerelease.bytes.to_a : [Float::INFINITY]
  end
  
  def match
    @match ||= @spec.match(/^v?(\d+)\.(\d+)\.(\d+)(\-(\w+))?$/)
  end
end

unless defined?(Float::INFINITY)
  Float::INFINITY = +1.0/0.0
end
