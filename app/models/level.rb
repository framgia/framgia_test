class Level < ActiveRecord::Base
  self.table_name = 'training_level'
  self.primary_key = 'level_id'
  default_scope -> { order('level_id') }

end