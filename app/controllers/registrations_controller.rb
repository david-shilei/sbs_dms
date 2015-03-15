class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    # add custom create logic here
    # fail params["employee_number"]
    params["user"]["password"] = params["user"]["employee_number"]
    super
  end

  def update
    super
  end
end