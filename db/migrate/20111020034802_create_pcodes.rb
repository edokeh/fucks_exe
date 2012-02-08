class CreatePcodes < ActiveRecord::Migration
  def self.up
    create_table :pcodes do |t|
      t.string :code
      t.integer :used_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :pcodes
  end
end
