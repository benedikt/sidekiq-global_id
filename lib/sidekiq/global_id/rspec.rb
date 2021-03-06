require 'sidekiq/global_id'
require 'rspec/sidekiq/matchers/have_enqueued_job'

Sidekiq::Testing.server_middleware do |c|
  c.prepend Sidekiq::GlobalId::ServerMiddleware
end

# Overrides rspec-sidekiq `have_enqueued_job` matcher to deserialize
# arguments.
class RSpec::Sidekiq::Matchers::HaveEnqueuedJob # rubocop:disable Style/ClassAndModuleChildren
  private

  def job_arguments(hash)
    if hash.is_a?(Hash)
      args = hash['arguments'] || hash['args']
      ActiveJob::Arguments.deserialize(args)
    end
  end

  # No need to normalize symbol keys, since we're able to
  # handle them properly.
  def normalize_arguments(args)
    args
  end
end
