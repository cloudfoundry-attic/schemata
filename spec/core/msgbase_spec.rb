require 'spec_helper'

describe Schemata::MessageBase do
  describe Schemata::MessageBase::ValidatingContainer do
    let(:data) { {"required" => "value"} }
    let(:validating_container) { Schemata::MessageBase::ValidatingContainer.define(schema) }
    let(:instance_validating_container) { validating_container.new(data) }
    let(:schema) do
      Membrane::SchemaParser.parse do
        {
            "required"             => String,
            optional("optional")   => String
        }
      end
    end

    describe ".new" do
      context 'when the field is an optional attribute' do
        let(:data) { {:optional => nil} }
        it 'allows it to be set to nil' do
          expect(instance_validating_container.optional).to be_nil
        end
      end

      context "when the keys are string in the data" do
        it { expect(instance_validating_container.required).to eq "value" }
      end

      context "when keys are symbols in the data due to DEA inconsistencies" do
        let(:data) { {:required => "value"} }

        it 'stringifies them temporarily' do
          # TODO Yajl decodes keys become strings. Thus, on the encoding side, Schemata should allow symbols,
          # but on the decoding side, it should expect strings. E.g. states in dea.find.droplet
          expect(instance_validating_container.required).to eq "value"
        end
      end
    end

    describe ".define" do
      context 'when the field is required' do
        it "doesn't it to be set to nil" do
          expect { instance_validating_container.required = nil }.to raise_error Membrane::SchemaValidationError
        end
      end

      context 'when the field is an optional attribute' do
        it 'allows it to be set to nil' do
          expect { instance_validating_container.optional = nil }.not_to raise_error
        end
      end
    end

    describe '#validate' do
      let(:required) { "foo" }
      let(:optional) { "bar" }

      subject do
        instance_validating_container.required = required
        instance_validating_container.optional = optional
        instance_validating_container.validate
      end

      it { expect { subject }.not_to raise_error }

      context 'when the schema an optional nil value' do
        let(:optional) { nil }
        it { expect { subject }.not_to raise_error }
      end

      context 'when the schema an optional wrong type value' do
        let(:optional) { 123 }
        it { expect { subject }.to raise_error Membrane::SchemaValidationError }
      end

      context 'when the schema a required nil value' do
        let(:required) { nil }
        it { expect { subject }.to raise_error Membrane::SchemaValidationError }
      end

      context 'when the schema a required wrong type value' do
        let(:required) { 123 }
        it { expect { subject }.to raise_error Membrane::SchemaValidationError }
      end
    end
  end

  describe Schemata::MessageBase::Dsl do
    describe '#define_aux_schema' do
      let(:dsl) do
        class TestDsl
          extend Schemata::MessageBase::Dsl
        end
      end

      after do
        dsl::AUX_SCHEMA
      end

      subject do
        dsl.define_aux_schema &schema
      end

      context 'when the aux schema is a Record' do
        let(:schema) { ->(_) { {"key" => String} } }

        it 'sets the AUX_SCHEMA constant to the parse schema' do
          subject
          expect(dsl::AUX_SCHEMA).to be_a Membrane::Schema::Record
        end

        it "correctly parses the schema" do
          subject
          expect(dsl::AUX_SCHEMA.schemas["key"].klass).to eq String
        end
      end

      context 'when the aux schema is not a Record' do
        let(:schema) { ->(_) { [String] } }
        it { expect { subject }.to raise_error Schemata::SchemaDefinitionError, "Schema must be a hash" }
      end
    end

    describe '#define_schema' do
      let(:dsl) do
        class TestDsl
          extend Schemata::MessageBase::Dsl
        end
      end

      after do
        dsl::SCHEMA
      end

      subject do
        dsl.define_schema &schema
      end

      context 'when the aux schema is a Record' do
        let(:schema) { ->(_) { {"key" => String} } }

        it 'sets the SCHEMA constant to the parse schema' do
          subject
          expect(dsl::SCHEMA).to be_a Membrane::Schema::Record
        end

        it "correctly parses the schema" do
          subject
          expect(dsl::SCHEMA.schemas["key"].klass).to eq String
        end
      end

      context 'when the aux schema is not a Record' do
        let(:schema) { ->(_) { [String] } }
        it { expect { subject }.to raise_error Schemata::SchemaDefinitionError, "Schema must be a hash" }
      end
    end
  end
end
