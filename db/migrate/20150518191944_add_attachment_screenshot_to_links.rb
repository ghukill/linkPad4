class AddAttachmentScreenshotToLinks < ActiveRecord::Migration
  def self.up
    change_table :links do |t|
      t.attachment :screenshot
    end
  end

  def self.down
    remove_attachment :links, :screenshot
  end
end
