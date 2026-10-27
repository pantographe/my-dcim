# frozen_string_literal: true

class Move
  class ConnectionPolicy < ApplicationPolicy
    skip_pre_check :allow_admins, only: :create?

    def create?
      return false if record.try(:move).try(:executed?)
      return true if user.admin?

      super
    end
  end
end
