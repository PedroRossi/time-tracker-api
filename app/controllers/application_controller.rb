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
class ApplicationController < ActionController::Base
    require 'json_web_token'
    
    #JSON WEB TOKEN
    protected
    # Validates the token and user and sets the @current_user scope
    def authenticate_request!
        if !payload || !JsonWebToken.valid_payload(payload.first)
            return invalid_authentication
        end

        load_current_user!
        invalid_authentication unless @current_user
    end

    # Returns 401 response. To handle malformed / invalid requests.
    def invalid_authentication
        render json: {error: 'Invalid Request'}, status: :unauthorized
    end

    private
    # Deconstructs the Authorization header and decodes the JWT token.
    def payload
        auth_header = request.headers['Authorization']
        token = auth_header.split(' ').last
        JsonWebToken.decode(token)
        rescue
        nil
    end

    # Sets the @current_user with the user_id from payload
    def load_current_user!
        @current_user = User.find_by(id: payload[0]['user_id'])
    end
    #FINISH JSON WEB TOKEN

    #HELPER METHODS
    def checkOwner
        if !@current_user.isOwner
            render json: {error: "User is not a owner."}, status: :unauthorized and return
        end
    end

    def checkAccepted
        if !@current_user.accepted
            render json: {error: "User not accepted."}, status: :unauthorized and return
        end
    end

    def checkSameUser(user_id)
        if !@current_user.isOwner && !(user_id == @current_user.id)
            render json: {error: "User is not the resource owner."}, status: :unauthorized and return
        end
    end
    
    def isProjectOwner(project_id)
        if !ProjectUser.where(user_id: @current_user.id, project_id: project_id).first.owner
            render json: {error: "User is not project owner."}, status: :unauthorized and return
        end
    end
    #FINISH HELPER METHODS


    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    # protect_from_forgery with: :exception
    # protect_from_forgery with: :null_session
end
