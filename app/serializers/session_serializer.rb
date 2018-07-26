class SessionSerializer < ActiveModel::Serializer
  attribute :token
  attribute :user

  private

  def token
    user.token
  end

  def user
    user
  end
end
