class Conclusion < ActiveRecord::Base
  self.table_name = 'training_conclusion'
  self.primary_key = 'conclusion_id'
  default_scope -> { order('conclusion_id') }
end