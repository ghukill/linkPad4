class Post < ActiveRecord::Base
	
	searchable do
    text :title, :body    
  end

end
