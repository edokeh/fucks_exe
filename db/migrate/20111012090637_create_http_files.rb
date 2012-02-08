class CreateHttpFiles < ActiveRecord::Migration
  def self.up
    create_table :http_files do |t|
      t.string :filename
      t.string :url
      t.integer :size
      t.integer :percent, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :http_files
  end
end
