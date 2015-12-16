# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# Although this is not needed for an api-only application, rails4 
# requires secret_key_base or secret_token to be defined, otherwise an 
# error is raised.
# Using secret_token for rails3 compatibility. Change to secret_key_base
# to avoid deprecation warning.
# Can be safely removed in a rails3 api-only application.
StudentSearchApi::Application.config.secret_token = 'f580fc2c4f635ad52a9b8135a0b5605312b2c033a5d0081a6ea1524d82d0c85962bcce5c1926d091a3b1b72561a6e4c15883572f8302e0ef903b03c4dcd7b15e'
