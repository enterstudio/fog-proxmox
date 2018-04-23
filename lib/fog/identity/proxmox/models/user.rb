# frozen_string_literal: true
# Copyright 2018 Tristan Robert

# This file is part of Fog::Proxmox.

# Fog::Proxmox is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# Copyright 2018 Tristan Robert

# This file is part of Fog::Proxmox.

# Fog::Proxmox is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Fog::Proxmox is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Fog::Proxmox. If not, see <http://www.gnu.org/licenses/>.

# frozen_string_literal: true

require 'fog/proxmox/models/model'

module Fog
  module Identity
    class Proxmox
      class User < Fog::Proxmox::Model
        identity :userid
        attribute :firstname
        attribute :lastname
        attribute :password
        attribute :email
        attribute :expire
        attribute :comment
        attribute :enable
        attribute :groups
        attribute :keys
        def to_s
          userid
        end

        def create
          service.create_user(attributes)
        end

        def destroy
          requires :userid
          service.delete_user(userid)
          true
        end

        def update
          requires :userid
          attr = attributes.reject { |k, _v| k == :userid }
          service.update_user(userid, attr)
        end

        def change_password
          requires :userid
          requires :password
          service.change_password(userid, password)
        end
      end
    end
  end
end
