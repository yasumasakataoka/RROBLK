require 'ror_blk/ror_blk'
require '2dc_jqgrid/2dc_jqgrid'
ActionController::Base.send :include,Ror_blk
Array.send :include, JqgridJson
ActionView::Base.send :include, Jqgrid
ActionController::Base.send :include,JqgridFilter
plsql.activerecord_class = ActiveRecord::Base
