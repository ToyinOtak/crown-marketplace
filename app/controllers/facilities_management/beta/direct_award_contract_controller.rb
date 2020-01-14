module FacilitiesManagement
  module Beta
    class DirectAwardContractController < FrameworkController
      skip_before_action :authenticate_user!
      before_action :set_page_detail
      before_action :set_page_model

      def sending_the_contract
        @page_data[:supplier] = 'Cleaning London LTD'
      end

      private

      def set_page_model
        @page_data[:model_object] = FacilitiesManagement::DirectAwardContract.new
      end

      # rubocop:disable Metrics/AbcSize
      def set_page_detail
        @page_data = {}
        @page_description = LayoutHelper::PageDescription.new(
          LayoutHelper::HeadingDetail.new(page_details(action_name)[:page_title],
                                          page_details(action_name)[:caption1],
                                          page_details(action_name)[:caption2],
                                          page_details(action_name)[:sub_title]),
          LayoutHelper::BackButtonDetail.new(page_details(action_name)[:back_url],
                                             page_details(action_name)[:back_label],
                                             page_details(action_name)[:back_text]),
          LayoutHelper::NavigationDetail.new(page_details(action_name)[:continuation_text],
                                             page_details(action_name)[:return_url],
                                             page_details(action_name)[:return_text],
                                             page_details(action_name)[:secondary_url],
                                             page_details(action_name)[:secondary_text])
        )
      end

      def page_details(action)
        @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
      end

      def page_definitions
        @page_definitions ||= {
          default: {
            back_url: ccs_patterns_path,
            back_label: 'Return to prototype index',
            back_text: 'View prototypes'
          },
          sending_the_contract: {
            back_url: ccs_patterns_prototypes_path,
            back_text: 'Back',
            page_title: 'Contract Details',
            caption1: 'Total facilities management',
            continuation_text: 'Confirm and send contract to supplier',
            return_url: ccs_patterns_prototypes_path,
            return_text: 'Return to procurement dashboard',
            secondary_text: 'Cancel, return to review your contract'
          }
        }.freeze
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end