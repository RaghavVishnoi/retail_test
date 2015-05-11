class RequestsCsv
  attr_accessor :from_date, :till_date
  include ApplicationHelper

  def self.absolute_file_path(file_name)
    File.join("#{Rails.root}/requests_csv", file_name) + '.csv'
  end

  def initialize(from, till)
    @from_date = Time.zone.parse(from) || Time.current
    @till_date = Time.zone.parse(till) || Time.current
    @from_date = @from_date.beginning_of_day
    @till_date = @till_date.end_of_day
  end

  def target_file_name
    "#{from_date.to_date.to_s}_#{till_date.to_date.to_s}"
  end

  def target_file_path
   self.class.absolute_file_path target_file_name
  end

  def file_name
    @file_name ||= "#{Time.current.to_i}"
  end

  def file_path
    self.class.absolute_file_path file_name
  end

  def file
    @file ||= File.new file_path, "w+"
  end

  def generate
    create_csv_file
    send_csv
  end

  def write_file text
    file.puts text
  end

  def branding_details_header
    Request.new.branding_details.map { |r| r[:field][:display_name] }
  end

  def branding_details_csv(request)
    request.branding_details.map { |details| field_values_str(details) }
  end

  def header
    [ 'Id', 'Request type', 'RSP Present in Shop?', 'Reason', 'CMO Name', 'Retailer Code', 'RSP Name', 'RSP Mobile number', 'RSP sales tag app user ID', 
      'City', 'state', 'Shop Name', 'Shop Address', 'Shop Owner Name', 'Shop Owner Phone', 'Avg. Store Monthly Sales',
      'Avg. Gionee Monthly Sales', 'Space Available in Store', 'Gionee GSB Present?', 'Type of SIS required?',
      'Is Gionee SIS installed in shop?', 'Is it main signage?', 'GSB installed outside?', 'Width', 'Height',
      'Type of GSB Requested?', 'Shop Requirements', branding_details_header, 'Remarks', 'status'
    ].flatten.join(',')
  end

  def create_csv_file
    write_file header
    Request.between_time(from_date, till_date).find_each(batch_size: 100) do |request|
      write_file to_csv(request)
    end
    file.close
    File.rename(file_path, target_file_path)
  end

  def to_csv(request)
    [ request.id, request_type_name(request), request.is_rsp, request.rsp_not_present_reason, request.cmo.try(:display_name), request.retailer_code, request.rsp_name,
      request.rsp_mobile_number, request.rsp_app_user_id, request.city, request.state, request.shop_name, request.shop_address,
      request.shop_owner_name, request.shop_owner_phone, monthly_sales_str(request.avg_store_monthly_sales, AVG_STORE_MONTHLY_SALES), monthly_sales_str(request.avg_gionee_monthly_sales, AVG_GIONEE_MONTHLY_SALES),
      request.space_available, request.is_gionee_gsb_present, request.type_of_sis_required, request.is_sis_installed, request.is_main_signage,
      request.is_gsb_installed_outside, request.width, request.height, request.type_of_gsb_requested, field_values_str(request.shop_requirements),
      branding_details_csv(request), request.remarks, request.status
    ].flatten.join(',')
  end

  def send_csv
    RequestMailer.delay.csv_mail(DEFAULT_EMAILS, target_file_name)
  end
end