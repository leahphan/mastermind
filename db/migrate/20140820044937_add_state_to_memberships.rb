class AddStateToMemberships < ActiveRecord::Migration
  def change
  	add_column :memberships, :state, :string
  	add_index :memberships, :state
  end
end
