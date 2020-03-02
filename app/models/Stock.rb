class Stock < ActiveRecord::Base

    has_many :trades
    has_many :users, through: :trades

end