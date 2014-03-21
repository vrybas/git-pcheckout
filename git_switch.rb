class GitSwitch

  def self.call(*args)
    new(*args).call
  end

  def initialize(branch)
  end

  def call
    true
  end
end
