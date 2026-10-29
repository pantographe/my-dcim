# frozen_string_literal: true

class Move
  class ConnectionPolicy < ApplicationPolicy
#     # pre_check :deny_readers # TODO: apply this for all move / projects models
#     skip_pre_check :allow_admins
#
#     def index?
#       true
#     end
#
#     def manage?
#       true
#     end
#
#     def destroy?
#       return true unless record.is_a?(Move::Connection)
#
#       !record.is_existing_connection_removal_batch?
#     end
  end
end
