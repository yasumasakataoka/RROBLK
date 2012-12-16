require 'test_helper'
require "rubygems"
require "ruby-plsql"
require File.dirname('D:\plsql\v07\vendor\plugins\ror_blk\lib') + '\lib\ror_blk.rb'
require 'ror_blk'
class RorBlkTest < ActiveSupport::TestCase
  # Replace this with your real tests.

    plsql.connection = OCI8.new("rails","tq6t7rjx","xe")
    @screenname_id = 'R_SCREENS'
    tmp_pre_screen = plsql.r_PreFields.all("where screen_name = :1
                                              and prefield_selection = :2",@screenname_id,1)
    person_id = "1"   
    @pre_screen = []                                  
    tmp_pre_screen.each do |i|
      pre_field = {}
      pre_field[:prefield_code] = i[:prefield_code]
      pre_field[:prefield_name] = getfobj(person_id,i[:prefield_code])
      pre_field[:prefield_type] = i[:prefield_type]
      pre_field[:prefield_length] = i[:prefield_length]
      pre_field[:prefield_datascale] = i[:prefield_datascale]
      @pre_screen << pre_field
    end

  end
  