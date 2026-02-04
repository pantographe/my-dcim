# frozen_string_literal: true

class PermissionScopeUser < ApplicationRecord
  # TODO: how to trigger PermissionScope changelog entry when creating or removing a PermissionScopeUser
  belongs_to :permission_scope, touch: true
  belongs_to :user
end
