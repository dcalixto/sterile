require "extensions/src/core/object"

module Sterile
  extend self

  # Trim whitespace from start and end of string and remove any redundant
  # whitespace in between.
  #
  #   " Hello  world! ".transliterate # => "Hello world!"
  #
  def trim_whitespace(string)
    string.gsub(/\s+/, " ").strip
  end

  # Remove HTML/XML tags from text. Also strips out comments, PHP and ERB style tags.
  #
  #   'Visit our <a href="http://example.com">website!</a>'.strip_tags # => "Visit our website!"
  #
  def strip_tags(string)
    # Remove HTML/XML tags, comments, PHP tags, ERB tags
    string
      .gsub(/<!--.*?-->/m, "")           # HTML comments
      .gsub(/<\?.*?\?>/m, "")            # PHP tags
      .gsub(/<%.*?%>/m, "")              # ERB tags
      .gsub(/<[^>]*>/, "")               # HTML/XML tags
      .gsub(/&[a-zA-Z0-9#]+;/, " ")      # HTML entities (basic cleanup)
      .gsub(/\s+/, " ")                  # Normalize whitespace
      .strip
  end

  # Transliterate to ASCII and strip out any HTML/XML tags.
  #
  #   "<b>nåsty</b>".sterilize # => "nasty"
  #
  def sterilize(string)
    strip_tags(transliterate(string))
  end

  # Transliterate to ASCII, downcase and format for URL permalink/slug
  # by stripping out all non-alphanumeric characters and replacing spaces
  # with a delimiter (defaults to '-').
  #
  #   "Hello World!".sluggerize # => "hello-world"
  #
  def sluggerize(string, delimiter = "-")
    sterilize(string).strip.gsub(/\s+/, "-").gsub(/[^a-zA-Z0-9\-]/, "").gsub(/-+/, delimiter).downcase
  end

  alias_method :to_slug, :sluggerize
end
