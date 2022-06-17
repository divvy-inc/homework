defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()
  
  test "JS alert" do
    navigate_to "https://the-internet.herokuapp.com/javascript_alerts"
    element = find_element(:xpath, "//*[@id='content']/div/ul/li[1]/button")
    click(element)

    assert dialog_text() == "I am a JS Alert"
    accept_dialog()
    
    result = find_element(:id, "result")
    assert inner_text(result) == "You successfully clicked an alert"
    assert attribute_value(result, "style") == "color: green;"
  end
  test "JS confirm" do
    navigate_to "https://the-internet.herokuapp.com/javascript_alerts"
    element = find_element(:xpath, "//*[@id='content']/div/ul/li[2]/button")
    click(element)

    assert dialog_text() == "I am a JS Confirm"

    # click 'OK' on the dialog box
    accept_dialog()
    result = find_element(:id, "result")
    assert inner_text(result) == "You clicked: Ok"
    assert attribute_value(result, "style") == "color: green;"

    # click 'Cancel' on the dialog box
    click(element)
    dismiss_dialog()
    assert inner_text(result) == "You clicked: Cancel"
  end
  test "JS prompt" do
    navigate_to "https://the-internet.herokuapp.com/javascript_alerts"
    element = find_element(:xpath, "//*[@id='content']/div/ul/li[3]/button")
    click(element)

    assert dialog_text() == "I am a JS prompt"
    prompt_input = "Welcome to Divvy"
    input_into_prompt(prompt_input)
    accept_dialog()

    result = find_element(:id, "result")
    assert inner_text(result) == "You entered: " <> prompt_input
    assert attribute_value(result, "style") == "color: green;"
  end
end
