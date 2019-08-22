require 'rake'
require 'aws-sdk-s3'

module LegalServices
  class DataUploadWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'ls'

    def perform(upload_id)
      upload = SupplyTeachers::Admin::Upload.find(upload_id)
      suppliers = upload.data

      SupplyTeachers::Upload.upload!(suppliers)

      upload.approve!
    rescue ActiveRecord::RecordInvalid => e
      summary = {
        record: e.record,
        record_class: e.record.class.to_s,
        errors: e.record.errors
      }

      fail_upload(SupplyTeachers::Admin::Upload.find(upload_id), summary)
    end

    private

    def fail_upload(upload, fail_reason)
      upload.fail!
      upload.update(fail_reason: fail_reason)
    end
  end
end
