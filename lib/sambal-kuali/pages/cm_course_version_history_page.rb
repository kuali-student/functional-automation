class CmCourseVersionHistoryPage < BasePage

  cm_elements

  def ifrm
    self.iframe(class: "fancybox-iframe")
  end

  element(:review_versions_button) {|b|b.ifrm.button(id: "CM-CourseVersion-Button-ShowVersions") }
  action(:show_versions) { |b| b.review_versions_button.click }


  element(:version_history_checkbox) { |row, b| b.ifrm.checkbox(id: "CM-CourseVersions-resultSet-checkbox_line#{row}_control") }
  element(:version_history_version) { |row, b| b.ifrm.div(id: "CM-CourseVersions-resultSet-version_line#{row}") }
  element(:version_history_courseStatus) { |row, b| b.ifrm.div(id: "CM-CourseVersions-resultSet-courseStatus_line#{row}") }
  element(:version_history_startTerm) { |row, b| b.ifrm.div(id: "CM-CourseVersions-resultSet-startTerm_line#{row}") }
  element(:version_history_endTerm) { |row, b| b.ifrm.div(id: "CM-CourseVersions-resultSet-endTerm_line#{row}") }
  action(:close_history_view) { |b| b.ifrm.a(id: 'CM-CourseVersion-Footer-Button-Close').click }
  action(:close) { |b| b.ifrm.a(title: "Close").click }

  def select_version_by_index(index)
      version_history_checkbox(index).set
  end

  def deselect_version_by_index(index)
      version_history_checkbox(index).clear
  end

end