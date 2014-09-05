class AddHatchbuckIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :hatchbuck_id, :string, null: false
  end
end
