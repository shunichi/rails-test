class Ad < ActiveRecord::Base
  attr_accessible :description, :email, :img_url, :name, :price, :seller_id
end
