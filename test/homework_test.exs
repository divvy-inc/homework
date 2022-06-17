defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  test "javascript alerts" do
    navigate_to "https://the-internet.herokuapp.com/javascript_alerts"

    element = find_element(:xpath, "//*[@id='content']/div/ul/li[1]/button")
    click(element)

    assert dialog_text() == "I am a JS Alert"
    dismiss_dialog()
    
    result = find_element(:id, "result")
    assert inner_text(result) == "You successfully clicked an alert"
    assert attribute_value(result, "style") == "color: green;"
  end
end
