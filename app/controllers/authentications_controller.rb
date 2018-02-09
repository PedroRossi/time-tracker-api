# Copyright 2015, Google, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START create]
class AuthenticationsController < ApplicationController
  require 'httparty'
  # Handle Google OAuth 2.0 login callback.
  #
  # POST /oauth2/google
  def create
    code = params[:code]
    redirect_uri = params[:redirect_uri]
    options = { :body => {:code => code, :redirect_uri => redirect_uri, :grant_type => "authorization_code", :client_id => "766044722529-hnq5ohm4o3f4jclfs3dq6plgt3ad7nmk.apps.googleusercontent.com", :client_secret => "BGmU7RIlp4HHUA4Fu9LuteDE" } }
    response = HTTParty.post("https://www.googleapis.com/oauth2/v4/token", options)
    infos = HTTParty.get("https://www.googleapis.com/oauth2/v1/userinfo", headers: {"Authorization" => "Bearer " + response["access_token"]})
    user = User.where(uid: infos["id"])
    
    if !user
      user = User.new
      user.name = infos["name"]
      user.email = infos["email"]
      user.uid = infos["id"]
      user.photo = infos["picture"]
      user.provider = "google"
      if !user.save
        render json: {status: :unprocessable_entity}
    
    
  end
# [END create] 
  # [START destroy]
  def destroy
    
  end
  # [END destroy]

end
