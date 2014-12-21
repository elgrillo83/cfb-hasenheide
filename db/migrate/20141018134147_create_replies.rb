class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :user, index: true
      t.references :event, index: true
      t.integer :status

      t.timestamps
    end
  end
end