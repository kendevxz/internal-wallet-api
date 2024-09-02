class User < Entity
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  def password=(new_password)
    self.password_digest = Digest::SHA256.hexdigest(new_password)
  end

  def authenticate(password)
    Digest::SHA256.hexdigest(password) == self.password_digest
  end
end
