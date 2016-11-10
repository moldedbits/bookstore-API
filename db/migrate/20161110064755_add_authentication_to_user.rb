class AddAuthenticationToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :authentication_token_digest, :string
    add_column :users, :authentication_token_expiry_date, :datetime
  end
end
