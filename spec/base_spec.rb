require 'spec_helper'

RSpec.describe Ruson::Base do
  class RusonBaseTestSubClass < Ruson::Base
    field :test_name
  end

  class RusonBaseTestSubClass2 < Ruson::Base
    field :test_name, name: 'source_key_name'
  end

  class RusonBaseTestSubClass3 < Ruson::Base
    field :object, class: RusonBaseTestSubClass
    field :objects, each_class: RusonBaseTestSubClass2
  end

  let(:text) { '{"object": { "test_name": "object_name" }, "objects": [ { "source_key_name": "1" }, { "source_key_name": "2" }, { "source_key_name": "3" } ] }' }

  it do
    obj = RusonBaseTestSubClass.new({})
    expect(obj).to respond_to :test_name
    expect(obj).to respond_to :test_name=
  end

  it do
    obj = RusonBaseTestSubClass.new({ test_name: 'test' })
    expect(obj.test_name).to eq 'test'
  end

  it do
    obj = RusonBaseTestSubClass.new({ root: { test_name: 'test' } }, root_key: :root)
    expect(obj.test_name).to eq 'test'
  end

  it do
    obj           = RusonBaseTestSubClass.new({ test_name: 'test' })
    obj.test_name = 'testtest'
    expect(obj.test_name).to eq 'testtest'
  end

  it do
    obj = RusonBaseTestSubClass.new({ test_name: 'test' }.to_json)
    expect(obj.test_name).to eq 'test'
  end

  it do
    obj = RusonBaseTestSubClass.new({ root: { test_name: 'test' } }.to_json, root_key: :root)
    expect(obj.test_name).to eq 'test'
  end

  it do
    obj           = RusonBaseTestSubClass.new({ test_name: 'test' }.to_json)
    obj.test_name = 'testtest'
    expect(obj.test_name).to eq 'testtest'
  end

  it do
    obj = RusonBaseTestSubClass2.new({ source_key_name: 'test' })
    expect(obj.test_name).to eq 'test'
  end

  it do
    obj = RusonBaseTestSubClass2.new({ source_key_name: 'test' }.to_json)
    expect(obj.test_name).to eq 'test'
  end

  it do
    obj = RusonBaseTestSubClass3.new(text)
    expect(obj.object.class).to eq RusonBaseTestSubClass
    expect(obj.object.test_name).to eq 'object_name'

    expect(obj.objects.first.class).to eq RusonBaseTestSubClass2
    expect(obj.objects.size).to eq 3
    expect(obj.objects[0].test_name).to eq '1'
    expect(obj.objects[1].test_name).to eq '2'
    expect(obj.objects[2].test_name).to eq '3'
  end
end
