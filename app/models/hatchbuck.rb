require 'net/http'
require 'uri'

class Hatchbuck
  def initialize(user)
    @api_key = ENV['HATCHBUCK_API_KEY'] || 'MG42cmdBS2M1MzdUdEhQbGMxZ3NmWFllVWoxbHloRnZBZ1JTamZsUExjSTE1'
    @uri = URI.parse("https://api.hatchbuck.com/api/v1/contact?api_key=#{@api_key}")
    @user = user
  end

  def post_data
    Net::HTTP.post_form(@uri, query_parameters(@user))
  end

  private
  def query_parameters(user)
    {
      'email' => user.email,
      'status' => user.id.to_s
      #'custom_fields' => [{
      #  'name' => 'Referral Code',
      #  'value' => user.referral_code
      #},
      #{
      #  'name' => 'Referred By',
      #  'value' => user.referrer_id.to_s
      #}]
    }
  end
end