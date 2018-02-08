class CreateTimelogs < ActiveRecord::Migration[5.1]
  def change
    create_table :timelogs do |t|
      t.string :description
      t.float :time
      t.belongs_to :project, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
