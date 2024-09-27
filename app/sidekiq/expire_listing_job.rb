class ExpireListingJob
  include Sidekiq::Job

  def perform
    Listing.active.where(created_at: ..3.hours.ago).find_each(&:expire_listing!)
  end
end
