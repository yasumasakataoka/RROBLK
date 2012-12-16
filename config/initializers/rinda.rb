# Be sure to restart your server when you modify this file.
require 'time'
 require 'drb/drb'
 DRb.start_service
 $ts = DRbObject.new_with_uri('druby://localhost:12345')
