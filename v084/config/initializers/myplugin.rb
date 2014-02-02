require 'ror_blk/ror_blkctl'
require '2dc_jqgrid/2dc_jqgrid'
require '2dc_jqgrid/3dc_jqgrid'
ActionController::Base.send :include,Ror_blkctl
ActionController::Base.send :include,Jqgrid
ActionView::Base.send :include,Ror_blkctl
Array.send :include, JqgridJson
ActionView::Base.send :include, Jqgrid
ActionController::Base.send :include,JqgridFilter

