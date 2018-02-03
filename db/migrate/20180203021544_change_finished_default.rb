class ChangeFinishedDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default :timelogs, :finished, false
  end
end
