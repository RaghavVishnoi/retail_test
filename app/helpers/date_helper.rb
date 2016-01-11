module DateHelper
	
    def date_valid(start_date,end_date)
        date_format(start_date,end_date)
    end

    def date_range(start_date,end_date)
        (end_date-start_date).to_i
    end

    def date_format(start_date,end_date)
        begin
            start_date = cast_date(start_date)
            end_date =  cast_date(end_date)
            range = date_range(start_date,end_date)
            if range > 31 || range < 0
                '1'
            end         
        rescue
            '0'
        end
    end

    def cast_date(date)
        DateTime.strptime(date, "%d-%m-%Y")
    end

end