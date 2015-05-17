class Link < ActiveRecord::Base
	searchable do
    text :title, :stored => true
    text :html, :stored => true
    string :URL, :stored => true
  end
end
