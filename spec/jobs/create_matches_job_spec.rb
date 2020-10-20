# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreateMatchesJob, type: :job do
  include ActiveJob::TestHelper
  include_context "sample employees and departments data"
  let(:lunch) { create(:lunch, lunch_date: Time.zone.today) }

  subject(:job) { described_class.perform_later(lunch.id) }

  it "queues the job" do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it "executes perform" do
    expect(Mystery::SchedulerService).to receive(:call).with(lunch: lunch)
    perform_enqueued_jobs { job }
  end
end
