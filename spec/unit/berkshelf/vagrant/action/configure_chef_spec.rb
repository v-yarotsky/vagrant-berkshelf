require 'spec_helper'

describe Berkshelf::Vagrant::Action::ConfigureChef do
  let(:app) { proc {} }

  let(:chef_solo_provisioner) do
    double("Vagrant::Provisioners::Chef::ChefSolo",
           :name => :chef_solo,
           :config => FakeConfig.new(:cookbooks_path => ["/path/to/my-cookbooks"]))
  end

  let(:shelf) { double("Shelf") }

  let(:env) do
    FakeConfig.new(
      :machine => {
        :config => {
          :vm => {
            :provisioners => [chef_solo_provisioner]
          },
          :berkshelf => {
            :enabled => true
          }
        }
      },
      :berkshelf => double("Berkshelf", :shelf => shelf)
    )
  end

  it "appends shelf path to vagrant's cookbooks_path" do
    chef_solo_provisioner.config.should_receive(:prepare_folders_config).with(shelf).and_return("/path/to/berkshelf-cookbooks")
    described_class.new(app, env).call(env)
    expect(chef_solo_provisioner.config.cookbooks_path).to include("/path/to/my-cookbooks", "/path/to/berkshelf-cookbooks")
  end
end

