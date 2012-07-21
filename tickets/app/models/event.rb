class Event < ActiveRecord::Base
  attr_accessible :artist, :description, :event_date, :price_high, :price_low
end
