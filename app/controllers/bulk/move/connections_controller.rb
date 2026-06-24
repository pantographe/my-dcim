# frozen_string_literal: true

module Bulk
  module Moves
    class ConnectionsController < BaseController
      before_action :set_move
      before_action :set_move_connections

      def destroy
        respond_to do |format|
          if @move_connections.map(&:destroy).all?
            # TODO: Use correct translation when available
            format.html { redirect_to move_connections_path(@move), notice: t("bulk.resource.destroy.flashes.destroyed", resource: "PDU"), status: :see_other }
          else
            # TODO: tell which records has not been removed
            # TODO: Use correct translation when available
            format.html { redirect_to move_connections_path(@move), alert: t("bulk.resource.destroy.flashes.not_destroyed", resource: "PDU"), status: :see_other }
          end
        end
      end

      private

      def set_move
        authorize! @move = Move.find(params[:move_id])
      end

      def scoped_move_connections
        @move.move_connections
      end

      def set_move_connections
        authorize! @move_connections = scoped_move_connections.where(id: params[:ids])
      end

      def default_authorization_policy_class
        Move::ConnectionPolicy
      end
    end
  end
end
