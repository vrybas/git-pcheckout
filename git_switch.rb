class GitSwitch < Struct.new(:branch)

  def self.call(*args)
    new(*args).call
  end

  def initialize(branch)
    self.branch = branch
  end

  def call
    self
  end
end
