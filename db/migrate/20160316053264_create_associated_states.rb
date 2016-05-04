class CreateAssociatedStates < ActiveRecord::Migration
  def change
    create_table :associated_states do |t|
    	t.timestamps
    end
       add_reference :associated_states, :user, index: true, foreign_key: true
       add_reference :associated_states, :state, index: true, foreign_key: true
  end
end
