class Product < ActiveRecord::Base
    belongs_to :category
    has_and_belongs_to_many :cart

    # mount_uploader :image, ImageUploader
    has_attached_file :image,
     styles: { medium: "300x300>", thumb: "100x100>" },
      default_url: "/images/:style/missing.png"
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
