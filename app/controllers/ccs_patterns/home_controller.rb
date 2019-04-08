module CcsPatterns
  class HomeController < FrameworkController
    require_permission :none, only: %i[index dynamic_accordian supplier_results_v1 supplier_results_v2 small_checkboxes]
    before_action :set_back_path, except: :index

    def index; end

    def dynamic_accordian; end

    def supplier_results_v1; end

    def supplier_results_v2; end

    def small_checkboxes; end

    def titles_checkboxes; end

    def numbered_pagination; end

    private

    def set_back_path
      @back_path = :back
    end
  end
end
