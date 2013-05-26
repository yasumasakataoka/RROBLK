# -*- coding: utf-8 -*-
require 'rubygems'
require 'prawn'
require 'prawn/measurement_extensions'

#PDFの初期化
pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)

#明朝体での文字列出力
pdf.font "C:/Windows/Fonts/HGRSKP.TTF"
pdf.text "表ソフトPDFがきちんと出力されるかテスト"
#ゴシック体での文字列出力
#pdf.font "ipag.ttf"
pdf.text "フォントを変えて出力してみたり..."

#ファイルの生成
pdf.render_file("sample.pdf")
