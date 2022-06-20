defmodule DynamicControls do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
  use Retry
  
  def go_to_dynamic_controls() do 
    navigate_to "https://the-internet.herokuapp.com/dynamic_controls"
  end

  def wait_for(func) do
    :timer.sleep(100)
    case func.() do
      true -> true
      false -> wait_for(func)
    end
  end

  # Start hound session and destroy when tests are run
  describe "Dynamic Controls" do
    hound_session()
    test "Remove checkbox" do
        go_to_dynamic_controls()
        
        checkbox = find_element(:id, "checkbox")
        remove_button = find_element(:xpath, "//*[@id='checkbox-example']/button")
        click(remove_button)
        assert find_element(:id, "loading")
        
        assert wait_for(fn -> element?(:id, "message") end)
        assert inner_text(find_element(:id, "message")) == "It's gone!"
    end
  end
end