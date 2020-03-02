class User < ActiveRecord::Base

    has_many :trades
    has_many :stocks, through: :trades

end