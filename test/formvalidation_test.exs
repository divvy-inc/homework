defmodule FormValidationTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  test "Open form " do
    navigate_to "https://the-internet.herokuapp.com/login"
    
  end

  test "Open Form" do
    navigate_to "https://the-internet.herokuapp.com/login"
    assert page_title() == "The Internet" 
  end

end
