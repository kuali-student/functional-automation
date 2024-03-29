class CourseOfferingInquiry < BasePage

  wrapper_elements
  frame_element

  expected_element :close_button_element

  def frm
    self.iframe(class: "fancybox-iframe")
  end

  value(:course_code) { |b| b.frm.div(data_label: "Course Offering Code").text }
  value(:course_title) { |b| b.frm.div(data_label: "Course Title").text }
  value(:course_term) { |b| b.frm.div(data_label: "Term").text }
  value(:course_credit_count) { |b| b.frm.div(data_label: "Credit Count").text }
  value(:credit_type) { |b| b.frm.div(data_label: "Credit Type").text }
  value(:grading_options) { |b| b.frm.div(id: 'gradingOptionId').text }
  value(:registration_options) { |b| b.frm.div(data_label: "Student Registration Options").text }
  value(:final_exam_type) { |b| b.frm.div(data_label: "Final Exam Type").text }
  value(:waitlist_state) { |b| b.frm.div(data_label: "Waitlists").p.text == "Active" }
  value(:honors_flag) { |b| b.frm.div(data_label: "Honors Flag").p.text == "YES" }
  element(:close_button_element) { |b| b.frm.div(id: 'KS-CourseOfferingEditWrapper-InquiryView').button(text: "Close")}
  def close
    close_button_element.click
    loading.wait_while_present
    # next line doesn't work, parent page field is present? even when dialog is open
    #@browser.div(id: 'courseOfferingManagementView').header(class: /uif-viewHeader/).h1.span.wait_until_present #synch to parent page so subsequent .visit call does not fail
    sleep 3
  end
  element(:delivery_formats_table) { |b| b.frm.div(id: "KS-CourseOfferingEditWrapper-InquiryView").table(index:1) }

  FORMAT_COLUMN = 0
  GRADE_ROSTER_LEVEL_COLUMN = 1
  FINAL_EXAM_COLUMN = 2
  FINAL_EXAM_ACTIVITY_COLUMN = 3

  def get_delivery_format  format
    delivery_format_row(format).cells[FORMAT_COLUMN].text
  end

  def get_grade_roster_level  format
    delivery_format_row(format).cells[GRADE_ROSTER_LEVEL_COLUMN].text
  end

  def get_final_exam_activity  format
    delivery_format_row(format).cells[FINAL_EXAM_ACTIVITY_COLUMN].text
  end

  def delivery_format_row(format)
    delivery_formats_table.rows.each do |df_row|
      format_text = df_row.cells[FORMAT_COLUMN].text
      return df_row if format_text[/^#{Regexp.escape(format)}$/]
    end
    return nil
  end

end