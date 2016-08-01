require 'spec_helper'

describe 'marathon', :type => 'class' do

  ['Ubuntu', 'RedHat', 'Fedora'].each do |operatingsystem|
    context "on #{operatingsystem}" do
      if operatingsystem == 'Ubuntu'
        let(:facts) { {
          :operatingsystem => operatingsystem,
          :osfamily        => operatingsystem,
          :lsbdistrelease  => '10.04',
        } }

        it { should compile.with_all_deps }

        it { should contain_file('/etc/init.d/marathon').with_ensure('link').with_target('/lib/init/upstart-job') }
      end

      if operatingsystem == 'RedHat'
        let(:facts) { {
          :operatingsystem           => operatingsystem,
          :osfamily                  => operatingsystem,
          :operatingsystemmajrelease => '6'
        } }

        it { should compile.with_all_deps }

        it { should contain_file('marathon-conf').with({
          :ensure => 'file',
          :path   => '/etc/init.d/marathon'
          }) }

        it { should contain_service('marathon').with({
          :provider => 'redhat'
          }) }
      end

      if operatingsystem == 'Fedora'
        let(:facts) { {
          :operatingsystem           => operatingsystem,
          :osfamily                  => operatingsystem,
          :operatingsystemmajrelease => '14'
        } }

        it { should compile.with_all_deps }

        it { should contain_file('marathon-conf').with({
          :ensure => 'file',
          :path   => '/etc/init.d/marathon'
          }) }
      end
    end

    it { should contain_class('marathon::install').that_comes_before('marathon::service') }

    context 'with a custom package name' do
      let(:params) { {'package' => 'marathon-custom-pkg-name' } }
      it { should contain_package('marathon').with_name('marathon-custom-pkg-name').with_ensure('present') }
    end

    context 'with a custom package name and version' do
      let(:params) { {
         'version' => '0.5.5',
         'package' => 'marathon-custom-pkg-name',
      } }
      it { should contain_package('marathon').with_name('marathon-custom-pkg-name-0.5.5').with_ensure('present') }
    end

    context 'with install_java param' do
      let(:params) { {
        :install_java => true,
        :java_version => 'java-1.7.0-openjdk'
      } }
      it { should contain_package('java').with_name('java-1.7.0-openjdk').with_ensure('installed') }
    end

    context 'with service_enable set to false' do
      let(:params) { {
        :service_enable => false
       } }
      it { should contain_service('marathon').with_enable('false') }
    end

    context 'with service_enable set to true' do
      let(:params) { {
        :service_enable => true
      } }
      it { should contain_service('marathon').with_enable('true') }
    end

    context 'with service_state set to stopped' do
      let(:params) { { :service_ensure => 'stopped'} }
      it { should contain_service('marathon').with_ensure('stopped') }
    end

    context 'When passing a non-bool as install_java' do
      let(:params) { {
        :install_java => 'hello'
      } }
      it { expect { should compile }.to raise_error(/is not a boolean/) }
    end

    context 'When passing a non-bool as service_enable' do
      let(:params) { {
        :service_enable => 'hello'
      } }
      it { expect { should compile }.to raise_error(/is not a boolean/) }
    end

    context 'specifiec to RedHat 7' do
      let(:facts) { {
        :operatingsystem           => 'RedHat',
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7'
      } }

      it { should contain_file('marathon-conf').with({
        :ensure => 'file',
        :path   => '/lib/systemd/system/marathon.service'
        }) }
    end
  end
end
