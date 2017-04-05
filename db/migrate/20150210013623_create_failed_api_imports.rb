class CreateFailedApiImports < ActiveRecord::Migration

  def change
    create_table :failed_api_imports do |t|
      t.string :message
      t.references :user, index: true

      t.timestamps
    end
  end

end
