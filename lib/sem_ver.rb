class SemVer
  class InvalidVersion < Exception; end

  include Comparable

  REGEX = /\Av?(\d+)\.(\d+)\.(\d+)(\-(\w+))?\Z/.freeze

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
    if valid? && other.valid?
      parts <=> other.parts
    else
      fail(InvalidVersion, to_s)
    end
  end

  def to_s
    return @spec unless valid?

    if prerelease
      "#{major}.#{minor}.#{patch}-#{prerelease}"
    else
      "#{major}.#{minor}.#{patch}"
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
    @match ||= @spec.match(REGEX)
  end
end

unless defined?(Float::INFINITY)
  Float::INFINITY = +1.0/0.0
end
