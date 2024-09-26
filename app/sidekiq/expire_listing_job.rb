class ExpireListingJob
  include Sidekiq::Job

  def perform
    Listing.active.where("created_at < NOW()").find_each(&:expire!)
  end
end
