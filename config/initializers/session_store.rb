# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hyewye_session',
  :secret      => 'c9438288ec0957b798bb4341508f9e222d5f15092ab1693ace36134f9d5b4dbdf58ff03e73df72211f035bc2b715bcd0875d2adf310cb7b16a11450ff372450c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
