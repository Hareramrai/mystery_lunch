# frozen_string_literal: true

shared_examples "deleted record not visible" do
  let(:klass_key) { described_class.to_s.underscore }

  describe "#destroy" do
    let(:record) { create(klass_key) }

    it "updates deleted_at to current_time" do
      record.destroy
      expect(record.deleted_at).to be_present
    end
  end

  describe ".all" do
    let(:record) { create(klass_key) }

    it "does not include the deleted record" do
      record.destroy

      expect(described_class.all).not_to include(record)
    end
  end
end
