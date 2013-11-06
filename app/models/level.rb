class Level < ActiveRecord::Base
  self.table_name = 'training_level'
  self.primary_key = 'level_id'
  default_scope -> { order('level_id') }

  before_create :default_active_values

  def default_active_values
    self.active_flag ||= 1
  end

end