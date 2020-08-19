class CreateMarkers < ActiveRecord::Migration[5.2]
  def change
    create_table :markers do |t|
      t.string :uni_id
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end