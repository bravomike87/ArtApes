class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    record.artwork.user != user
  end

  def destroy?
    record.user == user
  end

  def new?
    create?
  end


end
