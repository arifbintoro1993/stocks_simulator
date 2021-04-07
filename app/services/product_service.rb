module ProductService
    module_function

    def search(*args); ProductService::Search.new(*args).call; end
    def create(*args); ProductService::Create.new(*args).call; end
    def update(*args); ProductService::Update.new(*args).call; end
    def destroy(*args); ProductService::Destroy.new(*args).call; end
end