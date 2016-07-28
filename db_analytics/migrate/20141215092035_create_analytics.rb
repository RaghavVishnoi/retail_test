class CreateAnalytics < ActiveRecord::Migration
  def change
    Analytics.connection.execute %Q{
      create table analytics (
        id int primary key identity(1,1),
        format varchar,
        remote_ip varchar,
        protocol varchar,
        controller varchar,
        action varchar,
        created_at timestamp
      )
    }
  end
end
