defmodule DragAndDrop do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

  Code.require_file("reuseableCode/reuseables.exs")

  # Start hound session and destroy when tests are run
  hound_session()
  #####
  #I was not able to get this test working, it clicks on the first element as expected but then seems to use my actual cursor location.
  #If I manually hover over the location I want to drag to it works so it doesn't seem to be using the element coordinates I'm sending.
  #I have written similar more complex tests in the past using wdio so I'm sure it is possible to get this to work but it might require some serious digging.
  #####
  @tag runnable: false
  test "drag and drop" do

    navigate_to "https://the-internet.herokuapp.com/drag_and_drop"
    #Drag Forward
    Reuseables.letterBoxDragDrop("A", "B")
    #Drag Backward
    Reuseables.letterBoxDragDrop("A", "B")
    #Drag B column first
    Reuseables.letterBoxDragDrop("B", "A")

  end

end
