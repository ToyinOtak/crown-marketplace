module LegalServices
  class Journey::SupplierResults
    include Steppable
    def next_step_class
      Journey::SupplierDetails
    end
  end
end
