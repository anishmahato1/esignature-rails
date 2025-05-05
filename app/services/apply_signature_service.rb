#
# Service class to apply a signature to a document
#
class ApplySignatureService
  attr_reader :document

  def self.call(document)
    new(document).call
  end

  def initialize(document)
    @document = document
  end

  #
  # Apply a signature to a document
  #
  def call
    document_signature = document.document_signature
    raise SignatureServiceError, 'Document has no signature information' if document_signature.blank?

    signature = document_signature.signature
    raise SignatureServiceError, 'Signature image not found' if signature.blank? || signature.image.blank?

    # download to tmp files
    temp_pdf = download_to_temp_file(document.file.blob)
    temp_signature_image = download_to_temp_file(signature.image.blob)

    temp_signed_pdf = Tempfile.new(['signed-', '.pdf'], binmode: true)

    begin
      # Open the PDF with HexaPDF
      pdf_doc = HexaPDF::Document.open(temp_pdf.path)

      # validate page number
      page_index = document_signature.page_number - 1
      raise SignatureServiceError, 'Invalid page number' unless valid_page_index?(page_index, pdf_doc)

      # access the target page
      page = pdf_doc.pages[page_index]
      page_height = page.box.height

      # HexaPDF coordinates originate from bottom-left, convert from top-left
      pdf_y = page_height - document_signature.y_position - document_signature.height

      # import the signature image
      image = pdf_doc.images.add(temp_signature_image.path)

      # get the canvas for the page first (will create one if it doesn't exist)
      # if the page already has content, this will add to it
      canvas = page.canvas(type: :overlay)

      # add the signature image to the canvas at the specified position and size
      canvas.image(image, at: [document_signature.x_position, pdf_y],
                          width: document_signature.width,
                          height: document_signature.height)

      # Save the modified PDF to a temporary file
      pdf_doc.write(temp_signed_pdf.path, optimize: true)

      # attach the signed PDF back to the document
      document.file.attach(
        io: File.open(temp_signed_pdf.path),
        filename: "signed-#{document.file.filename.base}.pdf",
        content_type: 'application/pdf'
      )

      document.signed!

      true
    rescue StandardError => e
      document.failed!

      Rails.logger.error("Error applying signature: #{e.message}")
      raise SignatureServiceError, "Error applying signature: #{e.message}"
    ensure
      # clean up temporary files
      temp_pdf.close
      temp_pdf.unlink

      temp_signature_image.close
      temp_signature_image.unlink

      temp_signed_pdf.close
      temp_signed_pdf.unlink
    end
  end

  private

  def download_to_temp_file(blob)
    tempfile = Tempfile.new([blob.filename.base, File.extname(blob.filename.to_s)], binmode: true)

    tempfile.write(blob.download)
    tempfile.rewind

    tempfile
  end

  # Check if the page index is valid for the given PDF document
  def valid_page_index?(page_index, pdf_doc)
    page_index >= 0 && page_index < pdf_doc.pages.count
  end
end
