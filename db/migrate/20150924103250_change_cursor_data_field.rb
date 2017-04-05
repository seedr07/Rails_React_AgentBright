class ChangeCursorDataField < ActiveRecord::Migration

  def change
    change_column_null :cursors, :data, true
    change_column_default :cursors, :data, nil
  end

end
