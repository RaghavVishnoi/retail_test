# aws_config = YAML.load_file("#{Rails.root}/config/s3.yml")[Rails.env]

# if aws_config
#   CarrierWave.configure do |config|
#     config.fog_credentials = {
#       :provider               => 'AWS',
#       :aws_access_key_id      => aws_config['access_key'],
#       :aws_secret_access_key  => aws_config['secret_access_key'],
#       :region                 => aws_config['region']
#     }
#     config.fog_directory  = aws_config['bucket_name']
#   end
# end

# AWS_CONFIG = aws_config ? aws_config.with_indifferent_access : {}
