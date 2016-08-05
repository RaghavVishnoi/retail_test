class SetCurrentTimeStampInBeatroute < ActiveRecord::Migration
  def change
  	change_column :beatroutes,:created_at,:datetime,:default => Time.now
  	change_column :beatroutes,:updated_at,:datetime,:default => Time.now
  end
end
