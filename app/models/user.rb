class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"
    
    attr_accessible :email

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :send_welcome_email

    REFERRAL_STEPS = [
        {
            'count' => 5,
            "html" => "Baster",
            "class" => "two",
            "image" =>  ActionController::Base.helpers.asset_path("baster.jpg")
        },
        {
            'count' => 10,
            "html" => "Carving Knife",
            "class" => "three",
            "image" => ActionController::Base.helpers.asset_path("knife.jpg")
        },
        {
            'count' => 25,
            "html" => "Turkey",
            "class" => "four",
            "image" => ActionController::Base.helpers.asset_path("turkey.jpg")
        },
        {
            'count' => 50,
            "html" => "Pumpkin Pie",
            "class" => "five",
            "image" => ActionController::Base.helpers.asset_path("pie.jpg")
        }
    ]

    private

    def create_referral_code
      referral_code = SecureRandom.hex(3)[0..4]
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
          referral_code = SecureRandom.hex(3)[0..4]
          @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        UserMailer.delay.signup_email(self)
    end
end
