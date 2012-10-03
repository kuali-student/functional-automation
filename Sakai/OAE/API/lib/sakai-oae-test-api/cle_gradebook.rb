module GradebookFrame

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons

  # The frame object that contains all of the CLE Tests and Quizzes objects
  def frm
    self.frame(:src=>/TBD/)
  end

end

# The topmost page in a Site's Gradebook
class Gradebook
  include PageObject
  include GradebookFrame
  include GradebookMethods
end