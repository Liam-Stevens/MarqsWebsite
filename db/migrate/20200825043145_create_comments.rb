class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.belongs_to :submission
      t.references :marker, :foreign_key => true
      t.text :content
      t.timestamps
    end

    add_foreign_key :comments, :markers
  end
end
