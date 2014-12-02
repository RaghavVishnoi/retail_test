module Api
  module V1
    class ScreensController < BaseController
      skip_before_action :authenticate_user_from_token

      def index
        render :json => screens_json
      end

      private
        def screens_dir
          "#{Rails.root}/UIFileGenerator/Screen_Json"
        end

        def filename(file_path)
          File.basename(file_path, ".json")
        end

        def screens_json
          json = {}
          Dir.glob("#{screens_dir}/*.json").each do |f|
            json[filename(f)] = JSON.parse(File.read(f))
          end
          json
        end
    end
  end
end