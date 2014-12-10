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
    def file_name
      @file_name ||= "analytics_log_#{Time.current}"
    end

    def file
      File.new(file_name, "w+")
    end

    def write(str)
      file.puts str
      if file.size > 3.megabytes
        file.close
        Uploader.new(file_name).process
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
    attr_accessor :file_name

    def initialize(file_name)
      @file_name = file_name
    end

    def process
      upload_to_s3
      copy_to_redshift
      delete_from_s3
    end

    private

      def upload_to_s3
        s3_obj.write(Pathname.new(file_name))
      end

      def delete_from_s3
        bucket.objects.delete(obj_key)
      end

      def s3_obj
        bucket.objects[obj_key]
      end

      def obj_key
        file_name
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
      end
  end

  class Redshift
    
    def table_name
      "analytics"
    end

    def conn
      establish_connection "analytics"
    end

    def create_table
      conn.exec_params("create table #{table_name} (format varchar, remote_ip varchar, protocol varchar, controller varchar, action varchar)")
    end

    def copy(s3_file_name)
      conn.exec_params("copy analytics from '#{s3_file_name}' credentials 'aws_access_key_id=#{AWS_CONFIG[:access_key]};aws_secret_access_key=#{AWS_CONFIG[:secret_access_key]}' json;")
    end
  end
end