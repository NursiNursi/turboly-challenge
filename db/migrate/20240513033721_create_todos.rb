class CreateTodos < ActiveRecord::Migration[7.1]
  def change
    create_table :todos do |t|
      t.string :content
      t.date :due_date
      t.string :priority
      t.boolean :completed

      t.timestamps
    end
  end
end
