# use json adapter
ActiveModelSerializers.config.adapter = :json

# use camel case for keys
ActiveModelSerializers.config.key_transform = :camel_lower