ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
                                       :access_key_id => 'AKIAI25NMQARPZDAQHYA',
                                       :secret_access_key => '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',
                                       :server => 'email.us-east-1.amazonaws.com'
