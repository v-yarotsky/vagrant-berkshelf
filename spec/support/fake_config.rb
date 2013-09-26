class FakeConfig
  def initialize(config_hash)
    @config_hash = config_hash
  end

  def [](key)
    value = @config_hash[key.to_sym]
    value.is_a?(Hash) ? FakeConfig.new(value) : value
  end

  def method_missing(method_name, *)
    if @config_hash.key?(method_name.to_sym)
      self[method_name]
    else
      super
    end
  end
end

