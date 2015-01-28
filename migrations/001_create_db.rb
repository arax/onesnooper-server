#!/usr/bin/env ruby

# -------------------------------------------------------------------------- #
# Licensed under the Apache License, Version 2.0 (the "License"); you may    #
# not use this file except in compliance with the License. You may obtain    #
# a copy of the License at                                                   #
#                                                                            #
# http://www.apache.org/licenses/LICENSE-2.0                                 #
#                                                                            #
# Unless required by applicable law or agreed to in writing, software        #
# distributed under the License is distributed on an "AS IS" BASIS,          #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
# See the License for the specific language governing permissions and        #
# limitations under the License.                                             #
#--------------------------------------------------------------------------- #

require 'rubygems'
require 'sequel'

Sequel.migration do
  up do
    create_table(:one_monitoring) do
      #
      primary_key :id, :type => Bignum
      DateTime :timestamp, :null => false, :index => true

      #
      String :vm_id, :null => false, :index => true
      String :vm_deploy_id, :null => false, :index => true
      BigDecimal :vm_netrx, :default => 0
      BigDecimal :vm_nettx, :default => 0
      Float :vm_used_cpu, :default => 0.0
      BigDecimal :vm_used_memory, :default => 0
      String :vm_state, :null => false, :index => true

      #
      String :host_name, :null => false, :index => true
      String :host_arch, :default => 'unknown'
      String :host_model, :default => 'unknown'
      String :host_hypervisor, :null => false
      BigDecimal :host_ds_total, :default => 0
      BigDecimal :host_ds_used, :default => 0
      BigDecimal :host_ds_free, :default => 0
      Integer :host_total_cpu, :null => false
      Integer :host_cpu_speed, :default => 0
      Integer :host_used_cpu, :default => 0
      Integer :host_free_cpu, :default => 0
      BigDecimal :host_total_memory, :null => false
      BigDecimal :host_free_memory, :default => 0
      BigDecimal :host_used_memory, :default => 0

      #
      String :one_version, :null => false
    end
  end

  down do
    drop_table(:one_monitoring)
  end
end
