require 'jwt'

module DeepCloning
  # This is the main class responsible to evaluate the equations
  class DeepCloning
    VERSION = '0.1.1'.freeze


    def initialize(opts = {})
      @tenant = opts[:tenant]
      @app_id = opts[:app_id]
      @redirect_url = opts[:redirect_url]
      @state = opts[:state]
      @client_secret = opts[:client_secret]
      @resource = opts[:resource]
    end

    def authorization_url(login)
      "https://login.microsoftonline.com/#{@tenant}/oauth2/authorize?client_id=#{@app_id}&response_type=code&redirect_uri=#{@redirect_url}&response_mode=query&state=#{@state}&login_hint=#{login}"
    end


    def request_access_token(opts = {})
      code = opts[:code]
      session_state = opts[:session_state]
      state = opts[:state]

      params = {
        grant_type: 'authorization_code', client_id: @app_id, code: code,
        redirect_uri: @redirect_url, client_secret: @client_secret,
        resource: @app_id
      }
      token_url = "https://login.microsoftonline.com/#{@tenant}/oauth2/token"

      response = Net::HTTP.post_form(URI.parse(token_url), params)

      body = JSON.parse(response.body)

      answer = { status: :failed, data: {} }

      if response.code == '200'
        access_token = body['access_token']
        token_type = body['token_type']
        expires_in = body['expires_in']
        ext_expires_in = body['ext_expires_in']
        not_before = body['not_before']
        resource = body['resource']
        refresh_token = body['refresh_token']
        id_token = body['id_token']
        jwt_token = JWT.decode(id_token, nil, false)
        scope = body['scope']
        puts "#" * 90
        ap jwt_token
        puts "#" * 90

        puts "Access Token Acquired"
        answer[:data] = jwt_token[0]

        if not answer[:data].include?('email') and answer[:data].include?('unique_name')
          answer[:data]['email'] = jwt_token[0]['unique_name']
        end

        if answer[:data]['email']
          answer[:data]['email'] = answer[:data]['email'].downcase
          answer[:status] = :success
        end
      else
        answer[:msg] = response.body
      end
      return answer
    end
  end
end
