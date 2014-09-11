Spree::StockLocation.class_eval do
  validates_presence_of :country_id
  # Disabling as the following validation is very US specific as not all countries have state or zipcodes
  # also at time of account creation we do not have the other address information.
  # validates_presence_of :address1, :city, :zipcode
  # validate :state_id_or_state_name_is_present
  #
  # def state_id_or_state_name_is_present
  #   if state_id.nil? && state_name.nil?
  #       errors.add(:state_name, "can't be blank")
  #   end
  # end
end
