class AddBanToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :ban, :datetime
  end
end
