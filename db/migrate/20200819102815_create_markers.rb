class CreateMarkers < ActiveRecord::Migration[5.2]
  def change
    create_table :markers, :primary_key => 'marker_id' do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end

  ActiveRecord::Base.connection.execute("UPDATE SQLITE_SEQUENCE SET seq = 1700000 WHERE name = 'id'")
end