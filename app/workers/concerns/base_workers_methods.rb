module BaseWorkersMethods

  extend ActiveSupport::Concern

  def error(job, exception)
    self.class.error job, exception
  end

  module ClassMethods
    def error(job, exception)
      Rails.logger.info exception
      Rails.logger.info exception.backtrace.join("\n")
      Honeybadger.context job: job.inspect
      Honeybadger.notify exception
    end
  end
end
