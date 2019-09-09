class Setting < ApplicationRecord

  def self.code
    self.find_by_var(__method__.to_s).value
  end
end
