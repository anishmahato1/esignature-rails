module RequestTracking
  extend ActiveSupport::Concern

  # Browser patterns
  BROWSER_PATTERNS = {
    /Firefox/i => 'Firefox',
    /Chrome/i => 'Chrome',
    /Safari/i => 'Safari',
    /Opera|OPR/i => 'Opera',
    /MSIE|Trident/i => 'Internet Explorer'
  }.freeze

  # OS patterns
  OS_PATTERNS = {
    /Windows/i => 'Windows',
    /Mac OS/i => 'macOS',
    /Linux/i => 'Linux',
    /Android/i => 'Android',
    /iOS|iPhone|iPad|iPod/i => 'iOS'
  }.freeze

  # default value when no pattern matches
  DEFAULT_VALUE = 'Unknown'.freeze

  protected

  #
  # Captures metadata about the current Request
  #
  # @return [Hash] a hash containing request metadata
  #
  def capture_request_metadata
    {
      ip: request.remote_ip,
      user_agent: request.user_agent,
      browser: detect_from_patterns(request.user_agent, BROWSER_PATTERNS),
      os: detect_from_patterns(request.user_agent, OS_PATTERNS),
      location: get_location(request.remote_ip)
    }
  end

  private

  #
  # Detects a value by matching the input against a series of patterns
  #
  # @param input [String] the input to match against
  # @param patterns [Hash] a hash of regex patterns to values
  #
  # @return [String] the matched value or a default value
  #
  def detect_from_patterns(input, patterns)
    return DEFAULT_VALUE if input.blank?

    # find the first matching pattern
    patterns.each { |pattern, value| return value if pattern.match?(input) }

    DEFAULT_VALUE
  end

  #
  # TODO: implement using a geolocation service
  #
  # @param ip [String] the IP address to lookup
  #
  # @return [String] the location name or 'Unknown'
  #
  def get_location(_ip)
    DEFAULT_VALUE
  end
end
