# frozen_string_literal: true

class SecretService

  def initialize
    @secret = Rails.application.credentials.secret_key_base
  end

  # Return the encrypted dat along with the salt which can be parsed and used
  # during decryption
  def generate_secret(data)
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex(len)
    key   = ActiveSupport::KeyGenerator.new(@secret).generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    encrypted_data = crypt.encrypt_and_sign(data)

    "#{salt}$$#{encrypted_data}"
  end

  # Parse the salt and message from the encrypted data, then Decrypt to reveal
  # the secret
  def decode_secret(encrypted_data)
    salt, data = encrypted_data.split('$$')

    len   = ActiveSupport::MessageEncryptor.key_len
    key   = ActiveSupport::KeyGenerator.new(@secret).generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.decrypt_and_verify(data)
  end
end
