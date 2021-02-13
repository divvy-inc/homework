defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  # Define setup to run before each test
  setup do
    # Navigate to the main page
    navigate_to "https://the-internet.herokuapp.com/"
    :ok
  end

  test "add_remove_element" do
    # Navigate to Add/Remove Elements page
    add_remove = find_element(:xpath, ~s|//a[text()='Add/Remove Elements']|)
    add_remove |> click

    # Click Add Element button
    add_element_button = find_element(:xpath, ~s|//div[@id='content']//button|)
    add_element_button |> click()

    # Verify delete button is now displayed
    delete_button = find_element(:xpath, ~s|//div[@id='elements']//button|)
    assert(element_displayed?(delete_button), "Delete button was not displayed")
  end


end
