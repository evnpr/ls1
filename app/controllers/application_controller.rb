require 'aws/s3'
class ApplicationController < ActionController::Base
    protect_from_forgery
    AWS::S3::Base.establish_connection!(    
        :access_key_id  => 'AKIAJOTPI2TB6HPBPRCQ',
        :secret_access_key  => 'NasL4tpqCWN/+pZSwHxZ9UBBLmPulP+Zgw048ut/'
    )

    AWS::S3::DEFAULT_HOST.replace "s3-ap-southeast-1.amazonaws.com"

end
