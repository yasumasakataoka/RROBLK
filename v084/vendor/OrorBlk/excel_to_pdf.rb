# -*- coding: utf-8 -*-
# #require 'prawn'
# (日本語表示用に)IPAフォントをダウンロード
#http://ipafont.ipa.go.jp/index.html
require File.expand_path(File.join(File.dirname(__FILE__), 'set_excel_prn_info'))
#Prawn::Document.generate("implicit.pdf") do
#  text "Hello World"
#end

subapp = Test.new
subapp.blk_set_excel_info ARGV[0] 

