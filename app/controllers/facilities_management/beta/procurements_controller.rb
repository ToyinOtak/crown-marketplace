module FacilitiesManagement
  module Beta
    class ProcurementsController < FacilitiesManagement::FrameworkController
      before_action :set_procurement, only: %i[show edit update destroy]

      def index
        @procurements = current_user.procurements
      end

      def show; end

      def new
        @procurement = current_user.procurements.build
      end

      def create
        @procurement = current_user.procurements.create(procurement_params)

        if @procurement.save
          redirect_to facilities_management_beta_procurement_url(id: @procurement.id)
        else
          render :new
        end
      end

      def edit; end

      def update
        @procurement.assign_attributes(procurement_params)
        if @procurement.save(context: params[:step].to_sym)
          # ******************************************
          # if params['submit_choice'] == 'return'
          #   redirect_to facilities_management_beta_procurement_url(id: @procurement.id)
          # else
          #   redirect_to edit_facilities_management_beta_procurement_path(id: @procurement.id, step: params[:next_step], next_step: next_step(params[:next_step]))
          # end
          # ******************************************
          redirect_to FacilitiesManagement::ProcurementRouter.new(id: @procurement.id, step: params[:step]).route

        else
          render :edit
        end
      end

      # DELETE /procurements/1
      # DELETE /procurements/1.json
      def destroy
        @procurement.destroy

        respond_to do |format|
          format.html { redirect_to facilities_management_beta_procurements_url }
          format.json { head :no_content }
        end
      end

      private

      def procurement_params
        params.require(:facilities_management_procurement)
              .permit(
                :name,
                :contract_name,
                :procurement_data,
                :estimated_annual_cost,
                :tupe,
                :save_continue,
                :save_return
              )
      end

      def set_procurement
        @procurement = Procurement.find(params[:id])
      end

      def next_step(step)
        case step
        when 'contract_name'
          'estimated_annual_cost'
        when 'estimated_annual_cost'
          'tupe'
        when 'tupe'
          'contract_period'
        else
          '???'
        end
      end
    end
  end
end
