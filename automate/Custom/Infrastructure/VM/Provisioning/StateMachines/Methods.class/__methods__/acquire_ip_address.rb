# https://github.com/ramrexx/CloudForms_Infoblox/blob/master/automate/CloudForms_Infoblox/Integration/Infoblox/DDI/StateMachines.class/__methods__/infoblox_acquire_ipaddress.rb
# https://github.com/pemcg/manageiq-automation-howto-guide/blob/master/chapter15/options_hash.md#adding-network-adapters

def log_and_update_message(level, msg, update_message=false)
  $evm.log(level, "#{msg}")
  @task.message = msg if @task && (update_message || level == 'error')
end

def boolean(string)
  return true if string == true || string =~ (/(true|t|yes|y|1)$/i)
  return false
end

def set_task_nic_settings(nic_index, nic_settings)
  @task.set_option(:sysprep_spec_override, 'true') unless boolean(@task.get_option(:sysprep_spec_override))
  @task.set_nic_settings(nic_index, nic_settings)
  
  #Not sure why this gets nil
  #log_and_update_message(:info, "Provisioning object updated {:nic_settings => #{@task.options[:nic_settings].inspect}}")
end

begin
  case $evm.root['vmdb_object_type']
  when 'vm'
    @task   = $evm.root['vm'].miq_provision
  when 'miq_provision'
    @task   = $evm.root['miq_provision']
  else
    exit MIQ_OK
  end
  log_and_update_message(:info, "Provision: #{@task.id} Request: #{@task.miq_request.id} Type:#{@task.type}")

  hostname = 'test'
  dns_domain = 'example.com'
  fqdn = "#{hostname}.#{dns_domain}"
  dns_servers = '8.8.8.8'
  
  nic_index = 0
  
  nic_settings = {
    :ip_addr=>'192.168.1.88',
    :subnet_mask=>'255.255.0.0',
    :gateway=>'192.168.0.1',
    :addr_mode=>'static'
  }
  
  log_and_update_message(:info, "VM: #{hostname} nic: #{nic_index} nic_settings: #{nic_settings}")
  set_task_nic_settings(nic_index, nic_settings)
  
  @task.set_option(:linux_domain_name, dns_domain)
  log_and_update_message(:info, "Provisioning object updated {:linux_domain_name => #{@task.options[:linux_domain_name].inspect}}")
  @task.set_option(:dns_servers, dns_servers)
  log_and_update_message(:info, "Provisioning object updated {:dns_servers => #{@task.options[:dns_servers].inspect}}")
  @task.set_option(:dns_suffixes, dns_domain)
  log_and_update_message(:info, "Provisioning object updated {:dns_suffixes => #{@task.options[:dns_suffixes].inspect}}")
  @task.set_option(:vm_target_hostname, hostname)
  log_and_update_message(:info, "Provisioning object updated {:vm_target_hostname => #{@task.options[:vm_target_hostname].inspect}}")
  @task.set_option(:linux_host_name, fqdn)
  log_and_update_message(:info, "Provisioning object updated {:linux_host_name => #{@task.options[:linux_host_name].inspect}}") 

  #Windows?
  #:sysprep_computer_name
  #:sysprep_domain_name
  
  # Set Ruby rescue behavior
rescue => err
  log_and_update_message(:error, "[#{err}]\n#{err.backtrace.join("\n")}")
  exit MIQ_ABORT
end
