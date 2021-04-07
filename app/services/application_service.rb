class ApplicationService
  def call
    perform
  end

  def perform
    raise NotImplementedError
  end
end