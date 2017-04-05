class FixStatementDestriptionDefault < ActiveRecord::Migration
  def change
     change_column :plans, :statement_description, :string, default: nil
  end
end
