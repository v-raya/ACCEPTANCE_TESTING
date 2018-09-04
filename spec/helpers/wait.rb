# frozen_string_literal: true

module Wait
  def for_ajax(time: Capybara.default_max_wait_time)
    Timeout.timeout(time) do
      loop until finished_all_ajax_requests?
    end
  end
  module_function :for_ajax

  def for_document(time: Capybara.default_max_wait_time)
    Timeout.timeout(time) do
      document = Capybara.evaluate_script('document.readyState')
      loop unless document == 'complete'
    end
  end
  module_function :for_document

  def finished_all_ajax_requests?
    page.evaluate_script('(window.$ ? $.active : 0)').zero?
  end
  module_function :finished_all_ajax_requests?
end
