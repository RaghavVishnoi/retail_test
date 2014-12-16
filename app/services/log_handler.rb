class LogHandler
  class << self
    attr_accessor :handler

    def process(request)
      handler.write(RequestFormatter.format(request))
    end

    def handler
      @handler ||= Handler.new
    end
  end

  class Handler
    MAX_FILE_SIZE = 512.bytes

    def file_name
      @file_name ||= "analytics_log_#{Time.current}" #set_file_name
    end

    def dir
      "#{Rails.root}/analytics"
    end

    def file_path
      File.join(dir, file_name)
    end

    def file
      @file ||= File.new(file_path, "w+")
    end

    def write(str)
      file.puts str
      if file.size > MAX_FILE_SIZE
        file.close
        reset_handler
      end
    end

    def reset_handler
      # File.write(current_file, nil)
      LogHandler.handler = nil
      Uploader.new(file_path).process
    end

    private
      # def current_file
      #   File.join(dir, "current_file_name")
      # end

      # def existing_file_name
      #   @existing_file_name ||= File.read(current_file)
      # end

      # def set_new_file_name
      #   File.write(current_file, new_file_name)
      #   new_file_name
      # end

      # def set_file_name
      #   existing_file_name.present? ? existing_file_name : set_new_file_name
      # end

      # def new_file_name
      #   @new_file_name ||= "analytics_log_#{Time.current}"
      # end
  end

  class RequestFormatter
    def self.format(request)
      { 
        created_at: Time.current.strftime("%Y-%m-%d %H:%M:%S"),
        format: request.format.to_s,
        remote_ip: request.remote_ip,
        protocol: request.protocol,
        controller: request.params['controller'],
        action: request.params['action']
      }.to_json
    end
  end

  class Uploader
    attr_accessor :file_path

    def initialize(file_path)
      @file_path = file_path
    end

    def process
      upload_to_s3
    end

    def delete_from_s3
      bucket.objects.delete(obj_key)
    end
    handle_asynchronously :delete_from_s3

    private

      def upload_to_s3
        s3_obj.write(Pathname.new(file_path))
        delete_from_local
        copy_to_redshift
      end
      handle_asynchronously :upload_to_s3

      def delete_from_local
        File.delete(file_path)
      end

      def s3_obj
        bucket.objects[obj_key]
      end

      def obj_key
        File.basename(file_path)
      end

      def bucket
        @bucket ||= s3.buckets[AWS_CONFIG['redshift-bucket']]
      end

      def s3
        @s3 ||= AWS::S3.new(:access_key_id => AWS_CONFIG[:access_key], :secret_access_key => AWS_CONFIG[:secret_access_key])
      end

      def s3_file_name
        "s3://#{AWS_CONFIG['redshift-bucket']}/#{obj_key}"
      end

      def copy_to_redshift
        Redshift.new(s3_file_name, file_path).copy
      end
  end

  class Redshift
    attr_accessor :s3_file_name, :file_path

    def initialize(s3_file_name, file_path)
      @s3_file_name = s3_file_name
      @file_path = file_path
    end

    def copy
      Analytics.connection.execute("copy analytics from '#{s3_file_name}' credentials 'aws_access_key_id=#{AWS_CONFIG[:access_key]};aws_secret_access_key=#{AWS_CONFIG[:secret_access_key]}' json 'auto';")
      Uploader.new(file_path).delete_from_s3
    end
    handle_asynchronously :copy

  end
end