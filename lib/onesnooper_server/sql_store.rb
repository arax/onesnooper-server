require 'sequel'

# Class wrapping common features of all SQL-based
# stores. Using 'sequel' to abstract differences.
class OnesnooperServer::SqlStore < ::OnesnooperServer::Store

  # constant table name
  SQL_TABLE_NAME = :one_monitoring

  def save!(timestamp, data)
    ::OnesnooperServer::Log.debug "[#{self.class.name}] Saving #{timestamp.to_s} => #{data.inspect}"
    fail "DB connection has to be initialized from subclasses, " \
         "::OnesnooperServer::SqlStore cannot be used directly!" unless @db_conn

    if insert_data = data_in_vm_groups(timestamp, data)
      @db_conn[SQL_TABLE_NAME].multi_insert(insert_data)
    else
      ::OnesnooperServer::Log.warn "[#{self.class.name}] Skipping SQL INSERT for an empty dataset"
    end
  end

private

  # Converts parsed datagram payload into table rows
  # for direct insert into the DB.
  #
  # @param timestamp [DateTime] payload time stamp
  # @param data [Hash] hash-like parsed payload structure
  # @return [Array, NilClass] array with row hashes
  def data_in_vm_groups(timestamp, data)
    data_ary = []

    data['VM'].each do |vm_on_host|
      next if vm_on_host.blank?
      data_ary << {
        :timestamp => timestamp,
        :vm_id => vm_on_host['ID'],
        :vm_deploy_id => vm_on_host['DEPLOY_ID'],
        :vm_netrx => vm_on_host['POLL']['NETRX'],
        :vm_nettx => vm_on_host['POLL']['NETTX'],
        :vm_used_cpu => vm_on_host['POLL']['USEDCPU'],
        :vm_used_memory => vm_on_host['POLL']['USEDMEMORY'],
        :vm_state => vm_on_host['POLL']['STATE'],
        :host_name => data['HOSTNAME'],
        :host_arch => data['ARCH'],
        :host_model => data['MODELNAME'],
        :host_hypervisor => data['HYPERVISOR'],
        :host_ds_total => data['DS_LOCATION_TOTAL_MB'],
        :host_ds_used => data['DS_LOCATION_USED_MB'],
        :host_ds_free => data['DS_LOCATION_FREE_MB'],
        :host_total_cpu => data['TOTALCPU'],
        :host_cpu_speed => data['CPUSPEED'],
        :host_used_cpu => data['USEDCPU'],
        :host_free_cpu => data['FREECPU'],
        :host_total_memory => data['TOTALMEMORY'],
        :host_free_memory => data['FREEMEMORY'],
        :host_used_memory => data['USEDMEMORY'],
        :one_version => data['VERSION'],
      }
    end

    data_ary.empty? ? nil : data_ary
  end

end
