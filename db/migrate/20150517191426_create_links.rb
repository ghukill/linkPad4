class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :title
      t.string :URL
      t.text :html

      t.timestamps null: false
    end
  end
end
