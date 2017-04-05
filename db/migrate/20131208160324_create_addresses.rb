class CreateAddresses < ActiveRecord::Migration
  def change
  	enable_extension "hstore"
    create_table :addresses do |t|

	    t.references :owner, polymorphic: true
			t.string :type

	    t.string :address
			t.string :street
	    t.string :city
	    t.string :state
	    t.string :zip
	    t.string :county

	    t.hstore :data, default: {}

      t.timestamps
    end
  end
end
