require './spec/spec_helper.rb'

describe Rackspace::Volume do
  let(:credentials) { {
    accounts:        { 'myaccount' => 'dummy api key' },
    public_ssh_key:  'dummy ssh key',
  } }

  let(:params) { {
    credentials:  credentials,
    account:      'myaccount',
    name:         'myvolume',
  } }

  subject(:volume) { described_class.new(params) }

  let(:logger) { double(Rackspace::Logger, log: true) }

  let(:rackspace_credentials) { {
    rackspace_username:  'myaccount',
    rackspace_api_key:   'dummy api key',
    rackspace_region:    :ord,
  } }

  let(:api) { double(Rackspace::StorageApi, create: true) }

  before do
    allow(Rackspace::Logger).to receive(:new).and_return(logger)
  end

  before do
    allow(Rackspace::StorageApi).to receive(:new).and_return(api)
  end

  context "finding by id" do
    let(:params) { super().merge(volume_id: "dummy-volume-id") }
    let(:body) { {
      "volume" => {
        "display_name" => "myvol",
        "attachments"  => [{"device" => "/dev/xvdb"}],
        "volume_type"  => "SATA",
        "size"         => 75
      }
    } }
    let(:obj) { double(body: body) }

    it "finds" do
      expect(Rackspace::StorageApi).to receive(:new).with(rackspace_credentials).and_return(api)
      expect(api).to receive(:find_by_id).with("dummy-volume-id").and_return(obj)
      volume.device
    end
  end

  context "with defaults" do
    it "creates StorageApi instance" do
      expect(Rackspace::StorageApi).to receive(:new).with(rackspace_credentials).and_return(api)
      volume.create
    end

    it "creates a volume" do
      expect(api).to receive(:create).with({
        name:         'myvolume',
        volume_type:  'SATA',
        size:         75,
      })

      volume.create
    end
  end

  context "overriding volume size" do
    let(:params) { super().merge(size: 200) }

    it "creates a volume" do
      expect(api).to receive(:create).with(hash_including(size: 200))
      volume.create
    end
  end

  context "overriding volume type" do
    let(:params) { super().merge(volume_type: 'SSD') }

    it "creates a volume" do
      expect(api).to receive(:create).with(hash_including(volume_type: 'SSD'))
      volume.create
    end
  end

  context "overriding region" do
    let(:params) { super().merge(region: :iad) }

    it "creates StorageApi instance" do
      expect(Rackspace::StorageApi).to receive(:new).with(hash_including(rackspace_region: :iad))
      volume.create
    end
  end

  context "destroying" do
    let(:vol) { double(destroy: true) }

    before do
      allow(api).to receive(:find_by_name).with('myvolume').and_return(vol)
    end

    it "finds the volume" do
      expect(api).to receive(:find_by_name).with('myvolume')
      volume.destroy
    end

    it "destroys the volume" do
      expect(vol).to receive(:destroy)
      volume.destroy
    end
  end

end
