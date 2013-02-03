class ApplicationController < ActionController::Base
  protect_from_forgery
##  def initialize
##   @command_r = Hash.new
##  end
 def  command_r
       @command_r ||= Hash.new
  end  ## command_r
  def  show_data
       @show_data ||= Hash.new
  end  ## command_r
  def  session_data
       @session_data ||= Hash.new
  end  ## session_data
end  ## ApplicationController
