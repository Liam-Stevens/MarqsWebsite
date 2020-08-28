class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.belongs_to :submission
      t.references :marker, null: false
      t.text :content
      t.timestamps
    end

    add_foreign_key :comments, :markers, column: 'marker_id', primary_key: "marker_id"
  end
end
