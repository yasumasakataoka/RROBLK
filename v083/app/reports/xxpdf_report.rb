class PdfReportxx < Prawn::Document
  def to_pdf record,rcnt,sum998,sum999
    yield
    render
  end
end

