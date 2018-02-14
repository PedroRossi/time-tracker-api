class AddPausedToTimelogs < ActiveRecord::Migration[5.1]
  def change
    add_column :timelogs, :paused, :boolean, :default => false
  end
end
