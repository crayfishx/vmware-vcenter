# Copyright (C) 2013 VMware, Inc.
Puppet::Type.newtype(:esx_system_resource) do
  @doc = "This resource allows the configuration of system resources of a host that are viewed und er the 'System Resource Allocation' section of the vSphere client"

  def self.title_patterns
    identity = lambda { |x| x }
    [
      [
        /^([^:]+):([^:]+)$/,
        [ [:host, identity], [:name, identity] ]
      ],
      [
        /^([^:]+)$/,
        [[ :name, identity ]]
      ]
    ]
  end

  newparam(:name) do
    desc "The name of the resource, eg cpu_limit"
    isnamevar
  end

  newparam(:host) do
    desc "ESX hostname or ip address."
    isnamevar
  end

  newparam(:value) do
    desc <<-EOT 
    The value to assign to this resource setting, the value depends on the 
    type of resource being managed, supported values are;

    cpu_reservation
    ===============
      The CPU reservsation specified in MHz

    cpu_expandable_reservation
    ==========================
      Enable expandable reservation, valid values are true and false

    cpu_limit
    =========
      The CPU limit specified in MHz

    cpu_unlimited
    =============
      Enable unlimited CPU resources, valid values are true and false

    memory_reservation
    ==================
      Enable expandable memory reservation, valid values are true and false

    memory_limit
    ============
      The memory limit specified in MB

    memory_unlimited
    ================
      Enable unlimited memory resources, valuid values are true and false
    EOT

    case self[:name]

    when "cpu_limit"
      newvalues(/\d{1,}/, "unlimited")
      munge do |value|
        value = -1 if value == "unlimited"
        value
      end

    when  "cpu_reservation"
      newvalues(/\d{1,}/)

    when "cpu_expandable_reservation"
      newvalues(:true, :false)

    when "cpu_limit"
      newvalues(/\d{1,}/, "unlimited")
      munge do |value|
        value = -1 if value == "unlimited"
        value
      end

    when "memory_reservation"
      newvalues(/\d{1,}/)

    when "memory_expandable_reservation"
      newvalues(:true, :false)

    when "memory_limit"
      newvalues(/\d{1,}/, "unlimited")
      munge do |value|
        value = -1 if value == "unlimited"
        value
      end

    when "memory_unlimited"
      newvalues(:true,:false)
      munge do |value|
        if value == 'true'
          @resource[:memory_limit] = -1
        elsif value == 'false' && !(@resource[:memory_limit])
          @resource[:memory_limit] = 0
        end
      end
    end
  end
end
