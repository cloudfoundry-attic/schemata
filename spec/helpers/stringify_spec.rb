require 'spec_helper'

describe Schemata::Helpers do
  describe ".stringify" do
    subject { Schemata::Helpers.stringify_symbols(obj)  }

    context 'when the object is a String' do
      let(:obj) { "foo" }
      it { should eq obj }
    end

    context 'when the object is a symbol' do
      let(:obj) { :foo }
      it { should eq "foo" }
    end

    context 'when the object is a numeric' do
      let(:obj) { 123.03 }
      it { should eq obj }
    end

    context 'when the object is a nil' do
      let(:obj) { nil }
      it { should be_nil }
    end

    context 'when the object is a nil' do
      let(:obj) { true }
      it { should be_true }
    end

    context 'when the object is a nil' do
      let(:obj) { false }
      it { should be_false }
    end

    context 'when the object is an array' do
      context 'and one of the values is a symobl' do
        let(:obj) { [:foo, "bar", :baz] }
        it { should eq %w(foo bar baz) }
      end

      context 'and their is a nested array' do
        let(:obj) { [:foo, ["bar", :bar], :baz] }
        it { should eq ["foo", ["bar", "bar"], "baz"] }
      end
    end

    context "when the object is a hash" do
      context 'and the value is a symbol' do
        let(:obj) { { "foo" => :foo } }
        it { should eq("foo" => "foo") }
      end

      context 'and the key is a symbol' do
        let(:obj) { { :foo => 'foo'} }
        it { should eq("foo" => "foo") }
      end

      context 'and their is a nested hash' do
        let(:obj) { { :foo => {:foo => 'bar'}} }
        it { should eq("foo" => {"foo" => "bar"}) }
      end
    end

    context 'when the object is a nil' do
      let(:obj) { Object.new }
      it { expect { subject }.to raise_error Schemata::Helpers::StringifyError }
    end
  end
end
