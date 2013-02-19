require 'spec_helper'
require 'schemata/common/error'

describe Schemata do
  let(:backtrace) { %w(foo bar) }
  let(:error_message) { "error message" }
  let(:custom_error) do
    error = StandardError.new(error_message)
    error.set_backtrace(backtrace)
    error
  end

  describe Schemata::SchemataError do
    context 'when an error is explicitly passed in' do
      context 'and a message is not passed in' do
        subject { Schemata::SchemataError.new(custom_error) }

        its(:message) { should eq error_message }
        its(:backtrace) { should be_nil }
      end

      context 'and a message is passed in' do
        subject { Schemata::SchemataError.new(custom_error, "other message") }

        its(:message) { should eq "other message" }
        its(:backtrace) { should be_nil }
      end
    end

    context 'when no error is passed in' do
      context 'and it is a reraise' do
        subject do
          error = nil
          begin
            begin
              raise custom_error
            rescue
              raise Schemata::SchemataError.new
            end
          rescue => e
            error = e
          end
          error
        end

        its(:message) { should eq error_message }
        its(:source_backtrace) { should eq backtrace }

        it 'includes the re raised error' do
          expect(subject.backtrace.first).to match /error_spec\.rb/
        end

        it 'includes the chained error' do
          expect(subject.backtrace.last).to eq "bar"
        end
      end

      context 'and it is a standlone error' do
        subject { Schemata::SchemataError.new(nil, error_message) }

        its(:message) { should eq error_message }
        its(:backtrace) { should be_nil }
      end
    end
  end

  describe Schemata::UpdateAttributeError do
    let(:key) { "key" }
    subject { Schemata::UpdateAttributeError.new(key, custom_error) }

    its(:message) { should eq "#{key}: #{error_message}" }
    its(:to_s) { should eq "#{key}: #{error_message}" }
    its(:key) { should eq key }
    its(:backtrace) { should be_nil }
  end

  describe Schemata::IncompatibleVersionError do
    let(:msg_version) { 1 }
    let(:component_version) { 2 }

    subject { Schemata::IncompatibleVersionError.new(msg_version, component_version) }

    its(:message) { should eq "min message version #{msg_version} too high for component version #{component_version}" }
    its(:to_s) { should eq "min message version #{msg_version} too high for component version #{component_version}" }
    its(:msg_version) { should eq msg_version }
    its(:component_version) { should eq component_version }
    its(:backtrace) { should be_nil }
  end
end

