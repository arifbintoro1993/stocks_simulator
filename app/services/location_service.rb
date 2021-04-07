module LocationService
  module_function
  
  def search(*args); LocationService::Search.new(*args).call; end
  def create(*args); LocationService::Create.new(*args).call; end
  def update(*args); LocationService::Update.new(*args).call; end
  def destroy(*args); LocationService::Destroy.new(*args).call; end
end