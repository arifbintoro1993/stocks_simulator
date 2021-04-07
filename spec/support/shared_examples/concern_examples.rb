RSpec.shared_examples 'publish changes log' do
  before do
    allow(ChangeLoggerJobQueue).to(receive_message_chain(:new, :enqueue).and_return(true))
    allow(ChangeLoggerJobQueue).to(receive(:new).and_return(job_queue))
  end

  let(:job_queue) { ChangeLoggerJobQueue.new(object.changes_log_params) }

  it 'should publish changes log' do
    expect(object.persisted?).to eq true
    expect(job_queue).to have_received(:enqueue)
  end
end
