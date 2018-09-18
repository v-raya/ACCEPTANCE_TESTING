# frozen_string_literal: true

# form helper
module CardControlsHelper
  def click_save(card_id:)
    if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
      Capybara.execute_script("$('#{card_id} button:contains(\"Save\")').click()")
    else
      Capybara.find(card_id).click_button('Save')
    end
    Wait.for_ajax
  end

  def click_cancel(card_id:)
    if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
      Capybara.execute_script("$('#{self::CONTAINER} button:contains(\"Cancel\")').click()")
    else
      Capybara.find(card_id).click_button('Cancel')
    end
  end

  def edit_form(card_id:)
    if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
      Capybara.execute_script("$('#{card_id} a:contains(\"Edit\")').click()")
    else
      Capybara.find(card_id).click_link('Edit')
    end
  end

  def remove_form(card_id:)
    if %i[selenium_ie selenium_edge].include?(Capybara.current_driver)
      Capybara.execute_script("$('#{card_id} button:contains(\"Remove\")').click()")
    else
      Capybara.find(card_id).click_button('Remove')
    end
  end

  def not_editable?(card_id:)
    !editable?(card_id: card_id)
  end

  def editable?(card_id:)
    Capybara.find(card_id)[:class].include?('edit')
  end

  def attach_first_client(**args)
    sibling = within('#relationships-card ') do
      first('b', text: args[:first_name])
        .find(:xpath, '..').sibling('div')
    end
    sibling.first('span .glyphicon-option-vertical').click
    sibling.first('a', text: 'Attach').click
    Wait.for_ajax
  end
end
