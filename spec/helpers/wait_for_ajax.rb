# frozen_string_literal: true

module WaitForAjax
  def wait_for_ajax(time: Capybara.default_max_wait_time)
    Timeout.timeout(time) do
      loop until finished_all_ajax_requests?
    end
  end
  module_function :wait_for_ajax

  def finished_all_ajax_requests?
    page.evaluate_script('$.active').zero?
  end
  module_function :finished_all_ajax_requests?
end
