class Author < ApplicationRecord
has_many :books
validates :author_name, presence: true
 
end
