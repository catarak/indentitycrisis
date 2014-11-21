class User < ActiveRecord::Base
  belongs_to :group

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth ['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
      end
    end
  end

end