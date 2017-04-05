class Util

  def self.log_exception(exception)
    msg = exception.class.to_s; log msg
    msg = exception.to_s; log msg
    exception.backtrace.each do |line|
      log line
    end
  end

  def self.log msg
    Rails.logger.info msg
  end

  # To execute updates without tracking on Activity
  def self.without_tracking
    current = PublicActivity.enabled?
    PublicActivity.enabled = false
    yield
  ensure
    PublicActivity.enabled = current
  end

end
