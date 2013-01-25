require 'spec_helper'
require 'schemata/common/error'

describe Schemata do
  let(:backtrace) { %w(foo bar) }
  let(:message) { "message" }
  let(:exception) do
    error = StandardError.new(message)
    error.set_backtrace backtrace
    error
  end

  describe Schemata::Error do
    context 'when an exception is explicitly passed in' do
      context 'and a message is not passed in' do
        subject { Schemata::Error.new(exception) }

        its(:message) { should eq message }
        its(:backtrace) { should be_nil }
      end

      context 'and a message is passed in' do
        subject { Schemata::Error.new(exception, "other message") }

        its(:message) { should eq "other message" }
        its(:backtrace) { should be_nil }
      end
    end

    context 'when no exception is passed in' do
      context 'and it is a reraise' do
        subject do
          error = nil
          begin
            begin
              raise exception
            rescue
              raise Schemata::Error.new
            end
          rescue => e
            error = e
          end
          error
        end

        its(:message) { should eq message }
        its(:source_backtrace) { should eq backtrace }

        it 'includes the re raised exception' do
          expect(subject.backtrace.first).to match /error_spec\.rb/
        end

        it 'includes the chained exception' do
          expect(subject.backtrace.last).to eq "bar"
        end
      end

      context 'and it is a standlone exception' do
        subject { Schemata::Error.new(nil, message) }

        its(:message) { should eq message }
        its(:backtrace) { should be_nil }
      end
    end
  end

  describe Schemata::UpdateAttributeError do
    let(:key) { "key" }
    subject { Schemata::UpdateAttributeError.new(key, exception) }

    its(:message) { should eq "#{key}: #{message}" }
    its(:to_s) { should eq "#{key}: #{message}" }
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

