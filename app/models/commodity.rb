class Commodity < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :category

  enum category: {
    electronic_appliance: "electronic_appliance",
    electronic_accessory: "electronic_accessory",
    furniture: "furniture",
    men_wear: "men_wear",
    women_wear: "women_wear",
    shoes: "shoes"
  }
end
