class CreateNews < ActiveRecord::Migration[4.2]
  def change
    create_table :news do |t|
      t.string :title
      t.string :content
      t.boolean :internal, default: true

      t.timestamps null: false
    end
  end
end
