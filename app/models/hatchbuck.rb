require 'net/http'

class Hatchbuck
  def initialize(user)
    @api_key = ENV['HATCHBUCK_API_KEY'] || 'MG42cmdBS2M1MzdUdEhQbGMxZ3NmWFllVWoxbHloRnZBZ1JTamZsUExjSTE1'
    @uri = "https://api.hatchbuck.com/api/v1/contact?api_key=#{@api_key}"
    @user = user
    @http = Net::HTTP::Post.new(@uri)
  end

  def post_data
    @http.body = query_parameters(@user)
    response = Net::HTTP.new(@uri).start {|http| http.request(@http) }
    puts "Response #{response.code} #{response.message}: #{response.body}"
  end

  private
  def query_parameters(user)
    {
      'email' => user.email,
      'status' => user.id.to_s,
      'custom_fields' => [{
        'name' => 'Referral Code',
        'value' => user.referral_code
      },
      {
        'name' => 'Referred By',
        'value' => user.referrer_id.to_s
      }]
    }.to_json
  end
end
