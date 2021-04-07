module LogActivity
  def log_activity(metric = nil)
    start_time = Time.now
    success = true
    yield
  rescue StandardError => e
    success = false
    raise e
  ensure
    name, _, action = self.class.to_s.underscore.tr('/', '.').rpartition('.')
    track_time(metric, name, action, start_time, success)
  end

  def track_time
    raise NotImplementedError
  end
end
