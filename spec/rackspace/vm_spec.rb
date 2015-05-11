require './spec/spec_helper.rb'

describe Rackspace::Vm do
  let(:credentials) { {
    accounts:        { 'myaccount' => 'dummy api key' },
    public_ssh_key:  'dummy ssh key',
  } }

  let(:params) { {
    credentials:  credentials,
    account:      'myaccount',
    name:         'myserver',
  } }

  subject(:vm) { described_class.new(params) }

  let(:logger) { double(Rackspace::Logger, log: true) }

  let(:rackspace_credentials) { {
    rackspace_username:  'myaccount',
    rackspace_api_key:   'dummy api key',
    rackspace_region:    :ord,
  } }

  let(:personality) { [
    'path'     => '/root/.ssh/authorized_keys',
    'contents' => Base64.encode64('dummy ssh key')
  ] }

  let(:image) { double(id: 'some image') }

  let(:api) { double(Rackspace::ServerApi, image_by_name: image, create: true) }

  before do
    allow(Rackspace::Logger).to receive(:new).and_return(logger)
  end

  before do
    allow(Rackspace::ServerApi).to receive(:new).and_return(api)
  end

  context "with defaults" do
    it "creates ServerApi instance" do
      expect(Rackspace::ServerApi).to receive(:new).with(rackspace_credentials).and_return(api)
      vm.create
    end

    it "creates a vm" do
      expect(api).to receive(:create).with({
        name:         'myserver',
        flavor_id:    'general1-1',
        image_id:     'some image',
        personality:  personality,
      })

      vm.create
    end
  end

  context "overriding vm size" do
    let(:params) { super().merge(size: 2) }

    it "creates a vm" do
      expect(api).to receive(:create).with(hash_including(flavor_id: 'general1-2'))
      vm.create
    end
  end

  context "overriding image" do
    let(:image2) { double(id: 'image2-id') }
    let(:params) { super().merge(image_name: 'another image') }

    it "creates a vm" do
      allow(api).to receive(:image_by_name).with('another image').and_return(image2)
      expect(api).to receive(:create).with(hash_including(image_id: 'image2-id'))
      vm.create
    end
  end

  context "overriding flavor_id" do
    let(:params) { super().merge(flavor_id: 'some-flavor-id') }

    it "creates a vm" do
      expect(api).to receive(:create).with(hash_including(flavor_id: 'some-flavor-id'))
      vm.create
    end
  end

  context "overriding region" do
    let(:params) { super().merge(region: :iad) }

    it "creates ServerApi instance" do
      expect(Rackspace::ServerApi).to receive(:new).with(hash_including(rackspace_region: :iad))
      vm.create
    end
  end

  context "destroying" do
    let(:attachment) { double(destroy: true)                            }
    let(:server)     { double(attachments: [attachment], destroy: true) }

    before do
      allow(api).to receive(:attachments).and_return([])
      allow(api).to receive(:find_by_name).with('myserver').and_return(server)
    end

    it "finds the vm" do
      expect(api).to receive(:find_by_name).with('myserver')
      vm.destroy
    end

    it "destroys the vm" do
      expect(server).to receive(:destroy)
      vm.destroy
    end

    it "detaches volumes" do
      expect(attachment).to receive(:destroy)
      vm.destroy
    end
  end

  context "attached block storage volumes" do
    context "attaching volumes" do
      let(:vol)    { double                                 }
      let(:volume) { double(Rackspace::Volume, volume: vol) }
      let(:server) { double                                 }

      before do
        allow(api).to receive(:find_by_name).with('myserver').and_return(server)
      end

      it "attaches" do
        expect(server).to receive(:attach_volume).with(vol)
        vm.attach_volume(volume)
      end
    end

    context "building and attaching a volume" do
      let(:params) { super().merge(volume: {size: 100}) }
      let(:vol)    { double }
      let(:volume) { double(Rackspace::Volume, volume: vol, name: 'myvol') }
      let(:server) { double(attach_volume: true)                           }

      let(:v_params) { {
        account:      'myaccount',
        region:       :ord,
        credentials:  credentials,
        name:         'myserver-vol',
        size:         100,
      } }

      before do
        allow(api).to receive(:find_by_name).with('myserver').and_return(server)
        allow(api).to receive(:create).and_return(server)
        allow(Rackspace::Volume).to receive(:new).with(v_params).and_return(volume)
        allow(volume).to receive(:create).and_return(volume)
      end

      it "creates the volume" do
        expect(Rackspace::Volume).to receive(:new).with(v_params).and_return(volume)
        expect(volume).to receive(:create).and_return(volume)
        vm.create
      end

      it "attaches the volume" do
        expect(server).to receive(:attach_volume).with(vol)
        vm.create
      end

      context "querying volume" do
        let(:attachment) { double(volume_id: 'foo') }

        let(:v_params) { {
          account:      'myaccount',
          region:       :ord,
          credentials:  credentials,
          volume_id:    'foo',
        } }

        before do
          allow(server).to receive(:attachments).and_return([attachment])
        end

        it "returns the first attached volume" do
          expect(Rackspace::Volume).to receive(:new).with(v_params)
          vm.volume
        end
      end
    end
  end

end
