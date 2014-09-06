class AddHatchbuckIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :hatchbuck_id, :string
  end
end
