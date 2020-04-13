class Product < ActiveRecord::Base
    belongs_to :category
    # has_and_belongs_to_many :orders
    mount_uploader :image, ImageUploader
end
