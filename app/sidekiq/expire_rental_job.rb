class ExpireRentalJob
  include Sidekiq::Job

  def perform
    Listing.rented.find_each do |listing|
      time = Time.zone.now - 3.hours - listing.selected_bid.number_of_months.months
      if listing.created_at < time
        listing.closed!
      end
    end
  end
end
