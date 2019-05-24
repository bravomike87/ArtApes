class ProfilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def edit?
    record.user == user
  end

  def update?
    record.user == user
  end

  def bookings?
    record.user == user
  end

  def artworks?
    record.user == user
  end

  def requests?
    record.user == user
  end

  def destroy?
    record.user == user
  end


end
