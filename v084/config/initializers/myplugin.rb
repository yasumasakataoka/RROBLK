﻿require 'ror_blk/ror_blkctl'
require 'ror_blk/ror_blkinit'
include Ror_blkinit
require '2dc_jqgrid/2dc_jqgrid'
require '2dc_jqgrid/3dc_jqgrid'
require 'win32ole'
require 'barby/outputter/prawn_outputter'
require 'barby/barcode/code_39'
ActionController::Base.send :include,Ror_blkctl
ActionController::Base.send :include,Jqgrid
ActionView::Base.send :include,Ror_blkctl
Array.send :include, JqgridJson
ActionView::Base.send :include, Jqgrid
ActionController::Base.send :include,JqgridFilter
Ror_blkinit.crt_def_all_init 