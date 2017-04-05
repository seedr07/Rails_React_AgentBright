class AddImportSourceToLeads < ActiveRecord::Migration
  def change
    add_reference :leads, :import_source, polymorphic: true, index: true
  end
end
