module FacilitiesManagement
  module Beta
    class ProcurementDirectAwardContractController < FacilitiesManagement::Beta::FrameworkController
      before_action :set_page_detail
      before_action :set_page_model

      def sending_the_contract
        @page_data[:supplier] = 'Cleaning London LTD'
      end

      def review_and_generate_documents
        @page_data[:procurement_data] = { contract_name: 'School facilities London', supplier: 'Cabinet office', date_offer_expires: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), contract_number: 'RM330-DA2234-2019', contract_value: '£752,026', framework: 'RM3830', sub_lot: 'sub-lot 1a',
                                          initial_call_off_period: 7, initial_call_off_start_date: Date.new(2019, 11, 1), initial_call_off_end_date: Date.new(2016, 10, 31),
                                          expiration_date: DateTime.new(2019, 7, 23, 14, 20, 0).in_time_zone('London'), date_contract_received: DateTime.new(2019, 11, 20, 14, 0, 0).in_time_zone('London'), date_responded_to_contract: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_signed: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_closed: DateTime.new(2019, 11, 22, 14, 37, 0).in_time_zone('London'),
                                          mobilisation_period: 4, optional_call_off_extensions_1: 1, optional_call_off_extensions_2: 1, optional_call_off_extensions_3: nil, optional_call_off_extensions_4: nil,
                                          buildings_and_services: [{ building: 'Barton court store', service_codes: [] }, { building: 'CCS London office 5th floor', service_codes: ['C.13', 'C.20', 'N.1'] }, { building: 'Phoenix house', service_codes: [] }, { building: 'Vale court', service_codes: [] }, { building: 'W Cabinet office 3rd floor', service_codes: [] }] }
        @page_data[:contract_data] = { payment_method: 'BACS payment', invoicing_contact_details: [{ invoicing_contact: 'Robert Smith, FM administrator', address: [] }], authorised_representative: [{ representative: 'Attila the Hun, Warrior', address: ['Email: theruler@greatwarriors.com', 'Telephone: 0721 222 3334', 'Address: 21 Caucasus Rd, Westminster, London SW1A 2HQ'] }], notices: [{ notice_contact: 'Ildico Hun, Warrior`s wife', address: [] }], security_policy: 'Cabinet_office_document.pdf', local_government_pension_scheme: 'Not applicable' }
      end

      # rubocop:disable Metrics/AbcSize
      def show
        @page_data[:procurement_data] = { contract_name: 'School facilities London', supplier: 'Cleaning London LTD', date_offer_expires: DateTime.new(2019, 7, 7, 8, 2, 0).in_time_zone('London'), contract_number: 'RM330-DA2234-2019', contract_value: 752026, framework: 'RM3830', sub_lot: 'sub-lot 1a',
                                          initial_call_off_period: 7, initial_call_off_start_date: Date.new(2019, 11, 1), initial_call_off_end_date: Date.new(2016, 10, 31),
                                          contract_sent_date: DateTime.new(2019, 6, 22, 14, 20, 0).in_time_zone('London'), contract_accepted_date: DateTime.new(2019, 6, 23, 12, 20, 0).in_time_zone('London'), expiration_date: DateTime.new(2019, 7, 23, 14, 20, 0).in_time_zone('London'), date_contract_received: DateTime.new(2019, 11, 20, 14, 0, 0).in_time_zone('London'), date_responded_to_contract: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_signed: DateTime.new(2019, 6, 23, 14, 20, 0).in_time_zone('London'), date_contract_closed: DateTime.new(2019, 11, 22, 14, 37, 0).in_time_zone('London'),
                                          contract_start_date: Date.new(2019, 7, 17), contract_end_date: Date.new(2026, 7, 16),
                                          mobilisation_period: 4, optional_call_off_extensions_1: 1, optional_call_off_extensions_2: 1, optional_call_off_extensions_3: nil, optional_call_off_extensions_4: nil,
                                          buildings_and_services: [{ building: 'Barton court store', service_codes: [] }, { building: 'CCS London office 5th floor', service_codes: ['C.13', 'C.20', 'N.1'] }, { building: 'Phoenix house', service_codes: [] }, { building: 'Vale court', service_codes: [] }, { building: 'W Cabinet office 3rd floor', service_codes: [] }], call_off_documents_creation_date: DateTime.new(2019, 5, 14, 10, 47, 0).in_time_zone('London') }
        # TODO: When db intigrated this section can be refactored or removed
        @page_data[:supplier_details] = { title: 'Miss', full_name: 'Evelyn Smith', telephone: '0300 821 4554', email: 'evelyn@cleaningltd.co.uk', building_name: 'Cleaning London LTD', street_name: '', city: 'London', county: '', postcode: 'SW1 1ET' }
        @page_data[:procurement_data][:status] = find_status(request.path_info)
      end
      # rubocop:enable Metrics/AbcSize

      private

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def find_status(path)
        return 'awaiting response' if path.include?('awaiting-response')
        return 'awaiting signature' if path.include?('awaiting-signature')
        return 'signed' if path.include?('signed')
        return 'not-signed' if path.include?('not-signed')
        return 'declined' if path.include?('declined')
        return 'no response' if path.include?('no-response')
        return 'closed' if path.include?('closed')
      end
      # rubocop:enable Metrics/PerceivedComplexity
      # rubocop:enable Metrics/CyclomaticComplexity

      def set_page_model
        @page_data[:model_object] = FacilitiesManagement::ProcurementDirectAwardContract.new
      end

      # rubocop:disable Metrics/AbcSize
      def set_page_detail
        @page_data = {}
        @page_description = LayoutHelper::PageDescription.new(
          LayoutHelper::HeadingDetail.new(page_details(action_name)[:page_title],
                                          page_details(action_name)[:caption1],
                                          page_details(action_name)[:caption2],
                                          page_details(action_name)[:sub_title],
                                          page_details(action_name)[:caption3]),
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

      def set_continuation_text
        case find_status(request.path_info)
        when 'awaiting signature'
          'Confirm if contract signed or not'
        end
      end

      def set_secondary_text
        case find_status(request.path_info)
        when 'signed'
          'Make a copy of your requirements'
        else
          'Close this procurement'
        end
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
            page_title: 'Sending the contract',
            caption1: 'Total facilities management',
            continuation_text: 'Confirm and send contract to supplier',
            return_url: ccs_patterns_prototypes_path,
            return_text: 'Return to procurement dashboard',
            secondary_text: 'Cancel, return to review your contract'
          },
          review_and_generate_documents: {
            back_url: ccs_patterns_prototypes_path,
            back_text: 'Back',
            page_title: 'Review and generate documents',
            caption1: 'Total facilities management',
            continuation_text: 'Confirm and send contract to supplier',
            return_url: ccs_patterns_prototypes_path,
            return_text: 'Return to procurement dashboard',
            secondary_text: 'Cancel, return to review your contract'
          },
          show: {
            # TODO: add when the page has been added
            back_url: '#',
            back_label: 'Back',
            back_text: 'Back',
            page_title: 'Contract summary',
            caption1: 'School facilities London',
            continuation_text: set_continuation_text,
            # TODO: add when the page has been added
            return_url: '#',
            return_text: 'Return to procurement dashboard',
            secondary_text: set_secondary_text
          }
        }.freeze
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end