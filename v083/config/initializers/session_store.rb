# Be sure to restart your server when you modify this file.

V083::Application.config.session_store :cookie_store, key: '_v083_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# V082::Application.config.session_store :active_record_store
plsql.activerecord_class = ActiveRecord::Base
