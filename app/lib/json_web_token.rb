#
# JSON Web Token utility class
#
class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base || ENV.fetch('SECRET_KEY_BASE', nil)
  ALGORITHM = 'HS256'.freeze

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
                 .first

    decoded.with_indifferent_access
  rescue JWT::ExpiredSignature, JWT::DecodeError => e
    Rails.logger.error("JWT Error: #{e.message}")
    nil
  end
end
