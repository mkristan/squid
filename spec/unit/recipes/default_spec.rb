require 'spec_helper'

describe 'squid::default on Ubuntu 16.04' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do
    end.converge('squid::default')
  end

  it 'installs package squid3' do
    expect(chef_run).to install_package('squid3')
  end

  it 'templates /etc/squid3/squid.conf' do
    expect(chef_run).to create_template('/etc/squid3/squid.conf')
  end

  it 'templates /etc/squid3/squid.conf http deny all' do
    expect(chef_run).to render_file('/etc/squid3/squid.conf').with_content(
      'http_access deny all'
    )
  end

  it 'templates /etc/squid3/squid.conf icp deny all' do
    expect(chef_run).to render_file('/etc/squid3/squid.conf').with_content(
      'icp_access deny all'
    )
  end

  it 'templates /etc/squid3/squid.conf without include directory' do
    expect(chef_run).to_not render_file('/etc/squid/squid.conf').with_content(
      'Include additional configuration files'
    )
  end

  it 'file /etc/squid/conf.d/dummy.conf' do
    expect(chef_run).to_not create_file('/etc/squid/conf.d/dummy.conf')
  end

  it 'directory /etc/squid/conf.d/' do
    expect(chef_run).to_not create_directory('/etc/squid/conf.d')
  end
end

describe 'squid::default on CentOS 6' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '6.8') do
    end.converge('squid::default')
  end

  it 'installs package squid' do
    expect(chef_run).to install_package('squid')
  end

  it 'templates /etc/sysconfig/squid' do
    expect(chef_run).to create_template('/etc/sysconfig/squid')
  end

  it 'templates /etc/squid/squid.conf' do
    expect(chef_run).to create_template('/etc/squid/squid.conf')
  end

  it 'templates /etc/squid/squid.conf http deny all' do
    expect(chef_run).to render_file('/etc/squid/squid.conf').with_content(
      'http_access deny all'
    )
  end

  it 'templates /etc/squid/squid.conf icp deny all' do
    expect(chef_run).to render_file('/etc/squid/squid.conf').with_content(
      'icp_access deny all'
    )
  end

  it 'templates /etc/squid/squid.conf without include directory' do
    expect(chef_run).to_not render_file('/etc/squid/squid.conf').with_content(
      'Include additional configuration files'
    )
  end

  it 'file /etc/squid/conf.d/dummy.conf' do
    expect(chef_run).to_not create_file('/etc/squid/conf.d/dummy.conf')
  end

  it 'directory /etc/squid/conf.d/' do
    expect(chef_run).to_not create_directory('/etc/squid/conf.d')
  end
end

describe 'squid::default on FreeBSD 10' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'freebsd', version: '10.3') do
    end.converge('squid::default')
  end

  it 'creates missing directories' do
    expect(chef_run).to run_execute('squid -Nz').with(
      creates: '/var/squid/cache/00'
    )
  end

  it 'installs package squid' do
    expect(chef_run).to install_package('squid')
  end

  it 'creates /usr/local/etc/squid' do
    expect(chef_run).to create_directory('/usr/local/etc/squid')
  end

  it 'templates /usr/local/etc/squid/squid.conf' do
    expect(chef_run).to create_template('/usr/local/etc/squid/squid.conf')
  end

  it 'templates /usr/local/etc/squid/squid.conf http deny all' do
    expect(chef_run).to render_file('/usr/local/etc/squid/squid.conf').with_content(
      'http_access deny all'
    )
  end

  it 'templates /usr/local/etc/squid/squid.conf icp deny all' do
    expect(chef_run).to render_file('/usr/local/etc/squid/squid.conf').with_content(
      'icp_access deny all'
    )
  end

  it 'templates /usr/local/etc/squid/squid.conf without include directory' do
    expect(chef_run).to_not render_file('/usr/local/etc/squid/squid.conf').with_content(
      'Include additional configuration files'
    )
  end

  it 'file /etc/squid/conf.d/dummy.conf' do
    expect(chef_run).to_not create_file('/etc/squid/conf.d/dummy.conf')
  end

  it 'directory /etc/squid/conf.d/' do
    expect(chef_run).to_not create_directory('/etc/squid/conf.d')
  end
end

describe 'squid::default with conf.d and denyall attributes set on CentOS 6' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '6.8') do |node|
      node.set['squid']['config_include_dir'] = '/etc/squid/conf.d'
      node.set['squid']['http_access_deny_all'] = false
      node.set['squid']['icp_access_deny_all'] = false
    end.converge('squid::default')
  end

  # Required to make spec pass
  # https://github.com/sethvargo/chefspec/issues/260
  before do
    stub_command('/etc/squid/conf.d').and_return(false)
  end

  it 'installs package squid' do
    expect(chef_run).to install_package('squid')
  end

  it 'templates /etc/sysconfig/squid' do
    expect(chef_run).to create_template('/etc/sysconfig/squid')
  end

  it 'templates /etc/squid/squid.conf' do
    expect(chef_run).to create_template('/etc/squid/squid.conf')
  end

  it 'templates /etc/squid/squid.conf http deny all' do
    expect(chef_run).to_not render_file('/etc/squid/squid.conf').with_content(
      'http_access deny all'
    )
  end

  it 'templates /etc/squid/squid.conf icp deny all' do
    expect(chef_run).to_not render_file('/etc/squid/squid.conf').with_content(
      'icp_access deny all'
    )
  end

  it 'templates /etc/squid/squid.conf with include directory' do
    expect(chef_run).to render_file('/etc/squid/squid.conf').with_content(
      'include /etc/squid/conf.d/*.conf'
    )
  end

  it 'file /etc/squid/conf.d/dummy.conf' do
    expect(chef_run).to create_file('/etc/squid/conf.d/dummy.conf')
  end

  it 'directory /etc/squid/conf.d/' do
    expect(chef_run).to create_directory('/etc/squid/conf.d')
  end
end
