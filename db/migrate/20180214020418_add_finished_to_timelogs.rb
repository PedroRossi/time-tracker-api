class AddFinishedToTimelogs < ActiveRecord::Migration[5.1]
  def change
    add_column :timelogs, :finished, :boolean, :default => false
  end
end
