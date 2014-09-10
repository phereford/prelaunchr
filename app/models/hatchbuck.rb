class Hatchbuck
  include HTTParty

  def initialize(domain, user)
    @api_key = ENV['HATCHBUCK_API_KEY'] || 'MG42cmdBS2M1MzdUdEhQbGMxZ3NmWFllVWoxbHloRnZBZ1JTamZsUExjSTE1'
    @domain = domain
    @user = user
  end

  def post_data
    self.class.post("https://api.hatchbuck.com/api/v1/contact?api_key=#{@api_key}", body: query_parameters(@user).to_json, headers: { 'Content-Type' => 'application/json' } )
  end

  def post_custom_field_data
    self.class.put("https://api.hatchbuck.com/api/v1/contact?api_key=#{@api_key}", body: custom_field_parameters(@user).to_json, headers: { 'Content-Type' => 'application/json' })
  end

  private
  def query_parameters(user)
    {
      'api_key' => @api_key,
      'emails' => [{
        'address' => user.email,
        'type' => 'Work'
      }],
      'status' => {
        'name' => 'Customer'
      }
    }
  end

  def custom_field_parameters(user)
    {
      'emails' => [{
        'id' => @user.hatchbuck_id,
        'address' => @user.email,
        'type' => 'Work'
      }],
      'customFields' => [{
        'name' => 'referralCode',
        'value' => "http://#{@domain}/r/" + @user.referral_code
      },
      {
        'name' => 'referredBy',
        'value' => @user.referrer_id ? User.find(@user.referrer_id).try(:email) : ""
      }]
    }
  end
end
