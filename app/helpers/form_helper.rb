module FormHelper
  def setup_daycare(daycare)
    daycare.users.build if daycare.users.count.eql?(0)

    daycare
  end
end