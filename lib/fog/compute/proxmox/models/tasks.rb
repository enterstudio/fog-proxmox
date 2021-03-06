# frozen_string_literal: true

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

require 'fog/proxmox/models/collection'
require 'fog/compute/proxmox/models/task'

module Fog
  module Compute
    class Proxmox
      # class Tasks Collection of node
      class Tasks < Fog::Proxmox::Collection
        model Fog::Compute::Proxmox::Task
        attribute :node

        def new(attributes = {})
          requires :node
          super({ node: node }.merge(attributes))
        end

        def search(options = {})
          requires :node
          load_response(service.list_tasks(node.node, options), 'tasks')
        end

        def all
          search
        end

        def log(id)
          requires :node
          log = ''
          log_array = service.log_task(node.node, id, {})
          log_array.each do |line_hash|
            log += line_hash['t'].to_s + "\n"
          end
          log
        end

        def get(id)
          requires :node
          status_details = service.status_task(node.node, id)
          task_hash = status_details.merge(log: log(id))
          task_data = task_hash.merge(node: node, upid: id)
          new(task_data)
        end
      end
    end
  end
end
