class Link < ActiveRecord::Base
	
	# solr searchability
	searchable do
    text :title, :stored => true
    text :html, :stored => true
    string :URL, :stored => true
  end

  # paperclip attachments
  has_attached_file :screenshot, :styles => { :thumb => "320x240>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :screenshot, :content_type => /\Aimage\/.*\Z/

end
