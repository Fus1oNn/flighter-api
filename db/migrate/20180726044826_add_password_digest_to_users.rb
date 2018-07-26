class AddPasswordDigestToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :password_digest, :string

    User.all.each { |user| user.update(password: 'abc123')  }
  end

  def down
    remove_column :users, :password_digest
  end
end
