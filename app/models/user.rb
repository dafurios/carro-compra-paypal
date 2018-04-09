class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders
  has_many :products, through: :orders
  has_many :billings


  def cart
    orders.where(payed: false)

  end

  def has_any_oreders

    orders.where(payed: false) > 0


  end


end
