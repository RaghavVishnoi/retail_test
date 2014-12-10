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
    MAX_FILE_SIZE = 3.megabytes

    def file_name
      @file_name ||= "analytics_log_#{Time.current}"
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
        Uploader.new(file_path).process
        LogHandler.handler = nil
      end
    end
  end

  class RequestFormatter
    def self.format(request)
      { 
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
    # handle_asynchronously :process

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

      def delete_from_s3
        bucket.objects.delete(obj_key)
      end
      handle_asynchronously :delete_from_s3

      def s3_obj
        bucket.objects[obj_key]
      end

      def obj_key
        File.basename(file_path)
      end

      def bucket
        bucket ||= s3.buckets[AWS_CONFIG['redshift-bucket']]
      end

      def s3
        @s3 ||= AWS::S3.new(:access_key_id => AWS_CONFIG[:access_key], :secret_access_key => AWS_CONFIG[:secret_access_key])
      end

      def s3_file_name
        "s3://#{AWS_CONFIG['redshift-bucket']}/#{obj_key}"
      end

      def copy_to_redshift
        Redshift.copy(s3_file_name)
        delete_from_s3
      end
      handle_asynchronously :copy_to_redshift
  end

  class Redshift
    class << self
      def table_name
        "analytics"
      end

      def db_configuration
        ActiveRecord::Base.configurations['analytics']
      end

      def conn
        PGconn.new db_configuration
      end

      def create_table
        conn.exec_params("create table #{table_name} (format varchar, remote_ip varchar, protocol varchar, controller varchar, action varchar)")
      end

      def copy(s3_file_name)
        conn.exec_params("copy analytics from '#{s3_file_name}' credentials 'aws_access_key_id=#{AWS_CONFIG[:access_key]};aws_secret_access_key=#{AWS_CONFIG[:secret_access_key]}' json 'auto';")
      end
    end
  end
end