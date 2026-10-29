# frozen_string_literal: true

class Move
  class ConnectionPolicy < ApplicationPolicy
    pre_check :deny_readers
    skip_pre_check :allow_admins, only: %i[create? update?]

    def create?
      check_move_executed!
      return true if user.admin?

      super
    end

    def update?
      check_move_executed!
      true if user.admin?
    end

    private

    def check_move_executed!
      deny!(:move_executed) if record.try(:move).try(:executed?)
    end
  end
end
