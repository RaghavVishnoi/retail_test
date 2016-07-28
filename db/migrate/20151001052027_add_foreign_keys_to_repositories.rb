class AddForeignKeysToRepositories < ActiveRecord::Migration
  def change
  	add_reference :repositories, :documents, index: true, foreign_key: true
    add_reference :repositories, :levels, index: true, foreign_key: true
    add_reference :repositories, :tags, index: true, foreign_key: true
    add_reference :repositories, :users, index: true, foreign_key: true
  end
end
