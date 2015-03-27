class TimeHandler
  def self.preserve_time_zone(timezone)
    begin
      old_time_zone = Time.zone
      Time.zone = timezone
      yield
    rescue 
      nil
    ensure
      Time.zone = old_time_zone
    end
  end

  def self.day_time(timezone, seconds)
    preserve_time_zone(timezone) do 
      time = Time.current.beginning_of_day + seconds
      time.strftime("%H:%M") 
    end
  end

  def self.seconds(timezone, time)
    preserve_time_zone(timezone) { Time.zone.parse(time).seconds_since_midnight }
  end

  def self.select_zones
    ActiveSupport::TimeZone.all.map { |zone| [zone.name, zone.name] }
  end
end