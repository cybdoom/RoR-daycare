module FormHelper
  def setup_daycare(daycare)
    daycare.build_manager if daycare.manager.blank?

    daycare
  end
end