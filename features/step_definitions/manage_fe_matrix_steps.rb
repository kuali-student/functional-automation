When /^I edit a Standard Final Exam rule on the matrix$/ do
  @matrix = make FinalExamMatrix
  @matrix.add_rule :rule_obj =>  (make ExamMatrixRuleObject)
  @matrix.rules[0].edit :defer_save => true, :defer_submit => true
end

When /^I edit a Common Final Exam rule on the matrix$/ do
  @matrix = make FinalExamMatrix, :exam_type => "Common", :rule_requirements => "PHYS270"
  @matrix.add_rule :rule_obj =>  (make ExamMatrixRuleObject,
              :exam_type => 'Common', :days => "MTW", :start_time => "01:00", :st_time_ampm => "pm",
              :end_time => "03:00", :end_time_ampm => "pm")
  @matrix.rules[0].edit :defer_save => true, :defer_submit => true
end

When /^I open the Final Exam Matrix for ([^"]*)$/ do |term|
  @matrix = make FinalExamMatrix, :term_type => term
  @matrix.manage
end

When /^I add a Common Final Exam course rule to the Final Exam Matrix$/ do
  @matrix = make FinalExamMatrix, :term_type => "Winter Term"
  @matrix.add_rule :rule_obj => (make ExamMatrixRuleObject, :exam_type => "Common", :facility => '', :room => '' )
end

When /^I add Building and Room location data to the Requested Exam Offering Scheduling Information$/ do
  @matrix.rules[0].edit :facility => 'MTH', :room => '0304'
end

When /^I add a Standard Final Exam timeslot rule to the Final Exam Matrix$/ do
  @matrix = make FinalExamMatrix, :term_type => "Winter Term"
  @matrix.add_rule :rule_obj => (make ExamMatrixRuleObject)
end

When /^I add a Standard Final Exam text rule to the Final Exam Matrix$/ do
  @matrix = create FinalExamMatrix, :term_type => "Winter Term", :rule => "Free Form Text",
                   :free_text => "Course needs to match this text"
end

Given /^I have a Final Exam Matrix to which I have added multiple Standard Final Exam rule statements$/ do
  @matrix = make FinalExamMatrix, :term_type => "Winter Term"
  statement = []
  statement << (make ExamMatrixStatementObject,
                     :statement_option => ExamMatrixStatementObject::FREE_TEXT_OPTION,
                     :free_text => "To test the editing of the statement")
  statement << (make ExamMatrixStatementObject,
                     :statement_option => ExamMatrixStatementObject::TIME_SLOT_OPTION,
                     :statement_operator => 'AND',
                     :days => 'FS')

  rule = make ExamMatrixRuleObject,
              :exam_type => 'Standard', :days => "TH", :start_time => "02:00", :st_time_ampm => "pm",
              :end_time => "03:00", :end_time_ampm => "pm",
              :statements =>statement
  @matrix.add_rule :rule_obj => rule
end

Given /^I have added a Standard Final Exam timeslot rule to the Final Exam Matrix$/ do
  @matrix = make FinalExamMatrix, :term_type => "Winter Term"
  @matrix.add_rule :rule_obj => (make ExamMatrixRuleObject,  :days => "TH", :start_time => "06:00", :st_time_ampm => "am",
                                      :end_time => "07:00", :end_time_ampm => "am")
end

Given /^I have added a Common Final Exam course rule to the Final Exam Matrix$/ do
  @matrix = make FinalExamMatrix, :term_type => "Winter Term"
  @matrix.add_rule :rule_obj => (make ExamMatrixRuleObject, :exam_type => "Common")
end

When /^I edit the Standard Final Exam rule$/ do
  @matrix.rules[0].edit  :rsi_days => "Day 3"
  @matrix.rules[0].statements[0].edit  :days => "F"
end

When /^I edit the Common Final Exam course rule$/ do
  @matrix.rules[0].edit  :rsi_days => "Day 5"
  @matrix.rules[0].statements[0].edit  :courses => "CHEM272"
end

When /^I edit the newly created Standard Final Exam rule statements$/ do
  @matrix.rules[0].statements[1].edit :days => "TWH"
  @matrix.rules[0].statements[0].edit :free_text => "This statement has been edited"
end

When /^I have a Standard Final Exam group with a rule statement in the Final Exam Matrix$/ do
  @matrix = make FinalExamMatrix, :term_type => "Fall Term"
  statement = make ExamMatrixStatementObject,
                   :statement_option => ExamMatrixStatementObject::FREE_TEXT_OPTION,
                   :free_text => "To test whether statement is deleted"

  rule = make ExamMatrixRuleObject,
               :days => "TH", :start_time => "06:00", :st_time_ampm => "am",
               :end_time => "07:00", :end_time_ampm => "am",
               :statements => [ statement ]
  @matrix.add_rule :rule_obj => rule
end

When /^I choose to edit the existing rule statement$/ do
  @matrix.manage
  on(FEMatrixView).edit @matrix.rules[0], @matrix.rules[0].exam_type
end

When /^I delete the statement and attempt to update the rule$/ do
  @matrix.rules[0].statements[0].delete :defer_submit => true
end

When /^I delete an existing Standard Final Exam text rule to the Final Exam Matrix$/ do
  @matrix = make FinalExamMatrix, :term_type => "Winter Term"
  statement = (make ExamMatrixStatementObject,
                     :statement_option => ExamMatrixStatementObject::FREE_TEXT_OPTION,
                     :free_text => "To test whether rule is deleted")
  rule = make ExamMatrixRuleObject,
              :exam_type => 'Standard', :days => "WF", :start_time => "08:00", :st_time_ampm => "pm",
              :end_time => "09:00", :end_time_ampm => "pm",
              :statements => [ statement ]
  @matrix.add_rule :rule_obj => rule
  @deleted_rule_obj = @matrix.rules[0]

  @matrix.rules[0].delete
end

When /^I create a Final Exam Matrix with multiple rule statements$/ do
  @matrix = make FinalExamMatrix, :term_type => "Winter Term"
  statement = []
  statement << (make ExamMatrixStatementObject,
                   :statement_option => ExamMatrixStatementObject::FREE_TEXT_OPTION,
                   :free_text => "To test multi-statements")
  statement << (make ExamMatrixStatementObject,
                     :statement_option => ExamMatrixStatementObject::COURSE_OPTION,
                     :statement_operator => 'AND',
                     :courses => 'ENGL211')

  rule = make ExamMatrixRuleObject,
              :exam_type => 'Common', :days => "TH", :start_time => "02:00", :st_time_ampm => "pm",
              :end_time => "03:00", :end_time_ampm => "pm",
              :statements =>statement
  @matrix.add_rule :rule_obj => rule

end

When /^I add additional statements to the Common Final Exam rule on the Final Exam Matrix$/ do
  @matrix.add_additional_statements
end

When /^I view the Standard Final Exam rules on the Final Exam Matrix$/ do
  @matrix = make FinalExamMatrix
  @matrix.manage
end

When /^there is an Academic Term associated with a Final Exam matrix$/ do
  @matrix_term = make FinalExamMatrix, :term_type => "Fall Term"
end

When /^there is a second Academic Term that is not associated with any final exam matrix$/ do
  @matrix_second_term = make FinalExamMatrix, :term_type => "Summer Term"
end

When /^there is a second Academic Term associated with a Final Exam matrix$/ do
  @matrix_second_term = make FinalExamMatrix, :term_type => "Spring Term"
end

When /^there is an Academic Half Term that is not associated with any final exam matrix$/ do
  @matrix_halfterm = make FinalExamMatrix, :term_type => "Summer 1"
end

When /^I associate the second Term with the Final Exam matrix of the initial Term$/ do
  @matrix_second_term.manage
  on FEMatrixView do |page|
    page.term_type_select.select @matrix_term.term_type
    page.loading.wait_while_present
    page.submit
    page.loading.wait_while_present
  end
end

When /^I associate the Half Term with the Final Exam matrix of the initial Term$/ do
  @matrix_halfterm.manage
  on FEMatrixView do |page|
    page.term_type_select.select @matrix_term.term_type
    page.loading.wait_while_present
    page.submit
    page.loading.wait_while_present
  end
end

When /^I view the term in the Manage Final Exam Matrix screen$/ do
  @matrix_term.manage
end

When /^I view the initial term$/ do
  @matrix_term.manage
end

When /^I view the second term$/ do
  @matrix_second_term.manage
end

When /^I view the third term$/ do
  @matrix_third_term.manage
end

When /^I view the half term$/ do
  @matrix_halfterm.manage
end

When /^I associate the Half Term with the Final Exam matrix of the third Term$/ do
  @matrix_halfterm.manage
  on FEMatrixView do |page|
    page.term_type_select.select @matrix_second_term.term_type
    page.loading.wait_while_present
    page.submit
    page.loading.wait_while_present
  end
end

Then /^I should be able to choose any one of Day 1 to 6 for the rule$/ do
  on FEMatrixEdit do |page|
    for i in 1..6
      page.rsi_days.option( value: "#{i}").text.should == "Day #{i}"
    end
    page.cancel_rule
  end
  on(FEMatrixView).cancel
end

Then /^I can only view all the rules in the Final Exam Matrix$/ do
  on FEMatrixView do |page|
    page.standard_final_exam_table.rows[1..-1].each do |row|
      row.link(id: /delete_rule/).present?.should be_false
      row.link(id: /edit_rule/).present?.should be_false
    end
    page.common_final_exam_table.rows[1..-1].each do |row|
      row.link(id: /delete_rule/).present?.should be_false
      row.link(id: /edit_rule/).present?.should be_false
    end
  end
end

Then /^I cannot add a new rule to the Final Exam Matrix$/ do
  on FEMatrixView do |page|
    page.standard_final_exam_section.text.should_not match /Add/
    page.common_final_exam_section.text.should_not match /Add/
  end
end

Then /^I have the option of editing or deleting rules in the Final Exam Matrix$/ do
  on FEMatrixView do |page|
    page.standard_final_exam_table.rows[1..-1].each do |row|
      row.link(id: /delete_rule/).present?.should be_true
      row.link(id: /edit_rule/).present?.should be_true
    end
    page.common_final_exam_table.rows[1..-1].each do |row|
      row.link(id: /delete_rule/).present?.should be_true
      row.link(id: /edit_rule/).present?.should be_true
    end
  end
end

Then /^I have the option to add a new rule to the Final Exam Matrix$/ do
  on FEMatrixView do |page|
    page.standard_final_exam_section.text.should match /Add/
    page.common_final_exam_section.text.should match /Add/
  end
end

Then /^I should be able to see the newly created course rule in the Common Final Exam table$/ do
  @matrix.manage
  on FEMatrixView do |page|
    page.common_fe_target_row( @matrix.rules[0]).should_not == nil
  end
end

Then /^I should be able to see the location data for the exam specified in the course rule in the Common Final Exam table$/ do
  @matrix.manage
  on FEMatrixView do |page|
    page.common_fe_target_row( @matrix.rules[0]).should_not == nil
    page.get_common_fe_facility( @matrix.rules[0]).should match /Mathematics Bldg/
    page.get_common_fe_room( @matrix.rules[0]).should match /0304/
  end
end

Then /^I should be able to see the newly created timeslot rule in the Standard Final Exam table$/ do
  @matrix.manage
  on FEMatrixView do |page|
    page.get_standard_fe_day( @matrix.rules[0]).should match /#{@matrix.rules[0].rsi_days}/
    page.get_standard_fe_time( @matrix.rules[0]).should match /#{@matrix.rules[0].start_time} #{@matrix.rules[0].st_time_ampm.upcase}-#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm.upcase}/
  end
end

Then /^I should be able to see the newly created text rule in the Standard Final Exam table$/ do
  @matrix.manage
  on FEMatrixView do |page|
    page.standard_fe_target_row( @matrix.free_text).should_not == nil
    page.get_standard_fe_day( @matrix.free_text).should match /#{@matrix.rsi_days}/
    page.get_standard_fe_time( @matrix.free_text).should match /#{@matrix.start_time} #{@matrix.time_ampm.upcase}-#{@matrix.end_time} #{@matrix.time_ampm.upcase}/
  end
end

Then /^I should be able to see the edited timeslot rule in the Standard Final Exam table$/ do
  @matrix.manage
  on FEMatrixView do |page|
    page.get_standard_fe_day( @matrix.rules[0]).should match /#{@matrix.rules[0].rsi_days}/
    page.get_standard_fe_time( @matrix.rules[0]).should match /#{@matrix.rules[0].start_time} #{@matrix.rules[0].st_time_ampm.upcase}-#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm.upcase}/
  end
end

Then /^I should be able to see the edited course rule in the Common Final Exam table$/ do
  @matrix.manage
  on FEMatrixView do |page|
    page.common_fe_target_row( @matrix.rules[0]).should_not == nil
    page.get_common_fe_day( @matrix.rules[0]).should match /#{@matrix.rules[0].rsi_days}/
    page.get_common_fe_time( @matrix.rules[0]).should match /#{@matrix.rules[0].start_time} #{@matrix.rules[0].st_time_ampm.upcase}-#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm.upcase}/
  end
end

Then /^there should be a validation message displayed stating "([^"]+)"$/ do |exp_msg|
  on FEMatrixEdit do |page|
    page.loading.wait_while_present
    page.validation_message_text.should match /#{exp_msg}/
  end
end

Then /^I should be able to see the Common Final Exam rule with the multiple statements$/ do
  @matrix.manage
  on FEMatrixView do |page|
    page.get_common_fe_day( @matrix.rules[0]).should match /#{@matrix.rules[0].rsi_days}/
    page.get_common_fe_time( @matrix.rules[0]).should match /#{@matrix.rules[0].start_time} #{@matrix.rules[0].st_time_ampm.upcase}-#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm.upcase}/
  end
end

Then /^I should be able to see all the changes I have made on the Final Exam Matrix$/ do
  @matrix.manage
  on FEMatrixView do |page|
    page.standard_fe_target_row( @matrix.rules[0]).should_not == nil
  end
end

Then /^the deleted text rule should not exist on the Final Exam Matrix$/ do
  @matrix.manage
  on FEMatrixView do |page|
    page.standard_fe_target_row( @deleted_rule_obj).should == nil
    page.cancel
  end
end

Then /^the rules should be sorted on the Days and Time columns$/ do
  on FEMatrixView do |page|
    array_of_days = page.get_all_standard_fe_days
    ordered_days = array_of_days.sort

    array_of_days.should <=> ordered_days #.should == 0  #ie array is unchanged after sorting

    for day_no in 1..6 do
      array_of_times = page.get_all_standard_fe_times_for_day( "Day #{day_no}")
      sorted_times = array_of_times.sort
      array_of_times.should <=> sorted_times #).should == 0  #ie array is unchanged after sorting
    end
  end
end

Then /^the Exam Location indicator should be visible$/ do
  on FEMatrixView do |page|
    page.set_standard_exam_location.visible?.should == true
  end
end

Then /^the user is not able to access the Exam Location indicator$/ do
  on FEMatrixView do |page|
    page.set_standard_exam_location.attribute_value('disabled').should == "true"
  end
end

Then /^there is a message indicating that the final exam matrix is also used by the second term$/ do
  on FEMatrixView do |page|
    page.info_validation_message_text.should match /Matrix is also linked to #{@matrix_second_term.term_type}\./
  end
end

Then /^there is a message indicating that the final exam matrix is also used by the half term$/ do
  on FEMatrixView do |page|
    page.info_validation_message_text.should match /Matrix is also linked to #{@matrix_halfterm.term_type}\./
  end
end

Then /^there is no message indicating that the final exam matrix is also used by the half term$/ do
  on FEMatrixView do |page|
    if page.info_validation_message.exists?
      page.info_validation_message_text.should_not match /Matrix is also linked to #{@matrix_halfterm.term_type}\./
    end
  end
end

Then /^Standard Final Exam or Common Final Exam rules from the initial term are listed with the second term$/ do
  @matrix_second_term.manage
  on FEMatrixView do |page|
    page.standard_final_exam_section.visible?.should == true
    page.common_final_exam_section.visible?.should == true
  end
end

Then /^I should have a choice of terms from which to associate the Final Exam Matrix$/ do
  on FEMatrixView do |page|
    page.term_type_select.option(value: "kuali.atp.type.Fall").text.should == "Fall Term"
    page.term_type_select.option(value: "kuali.atp.type.Spring").text.should == "Spring Term"
  end
end

Given /^that the Course Offering has a CO-driven final exam that is marked to use the matrix and exists on the Final Exam Matrix for the term$/ do
  @course_offering = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "CHEM131"

  unless @course_offering.exists?
    course_offering = make CourseOffering, :term=> Rollover::OPEN_EO_CREATE_TERM,
                            :course => 'CHEM131', :suffix => ' '
    course_offering.delivery_format_list[0].format = 'Lecture'
    course_offering.delivery_format_list[0].grade_format = 'Lecture'
    course_offering.delivery_format_list[0].final_exam_activity = 'Lecture'
    course_offering.create

    activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                                :format => 'Lecture Only', :activity_type => 'Lecture'
  end

  @matrix = make FinalExamMatrix, :term_type => "Spring Term"
  @matrix.create_common_rule_matrix_object_for_rsi( @course_offering.course)
end

Given /^I manage a CO-driven exam offering with RSI generated from the exam matrix$/ do
  @course_offering = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "CHEM131"

  @matrix = make FinalExamMatrix, :term_type => "Spring Term"
  @matrix.create_common_rule_matrix_object_for_rsi( @course_offering.course)

  @course_offering.create

  @eo_rsi = make EoRsiObject, :override_matrix => true,
                 :day => @matrix.rules[0].rsi_days,
                :start_time => "#{@matrix.rules[0].start_time} #{@matrix.rules[0].st_time_ampm}",
                :end_time => "#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm}",
                :facility =>@matrix.rules[0].facility,
                :room => @matrix.rules[0].room

  on(ManageCourseOfferings).view_exam_offerings
end

Then /^the Requested Scheduling Information for the Exam Offering should be populated$/ do
  on ViewExamOfferings do |page|
    page.co_eo_days.should match /#{Regexp.escape(@matrix.rules[0].rsi_days)}/
    page.co_eo_st_time.should match /#{Regexp.escape(@matrix.rules[0].start_time)}/
    page.co_eo_end_time.should match /#{Regexp.escape(@matrix.rules[0].end_time)}/
  end
end

Given /^that the Course Offering has a CO-driven final exam that is marked to use the matrix but does not exist on the Final Exam Matrix for the term$/ do
  @course_offering = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "CHEM242"
  unless @course_offering.exists?
    course_offering = make CourseOffering, :term=> Rollover::OPEN_EO_CREATE_TERM,
                           :course => "CHEM242",
                           :suffix => ' ',
                           :final_exam_driver => "Final Exam Per Course Offering"
    course_offering.delivery_format_list[0].format = "Lecture/Lab"
    course_offering.delivery_format_list[0].grade_format = "Lab"
    course_offering.delivery_format_list[0].final_exam_activity = ""
    course_offering.create

    activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                               :format => "Lecture/Lab", :activity_type => "Lecture"

    activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                               :format => "Lecture/Lab", :activity_type => "Lab"

    si_obj =  make SchedulingInformationObject, :days => "M",
                   :start_time => "12:00", :start_time_ampm => "pm",
                   :end_time => "02:50", :end_time_ampm => "pm",
                   :facility => 'CHM', :room => '1326'
    activity_offering.add_req_sched_info :rsi_obj => si_obj
  end
end

Then /^the Schedule Information for the Exam Offering should be blank$/ do
  on ViewExamOfferings do |page|
    page.co_eo_days.should == ""
    page.co_eo_st_time.should == ""
    page.co_eo_end_time.should == ""
  end
end

Given /^I ensure that the Course Offering exists on the Final Exam Matrix$/ do
  @matrix = make FinalExamMatrix, :term_type => @calendar.terms[0].term_type
  statement = []
  statement << (make ExamMatrixStatementObject, :statement_option => ExamMatrixStatementObject::COURSE_OPTION,
                     :courses => @course_offering.course)
  rule = make ExamMatrixRuleObject, :exam_type => 'Common', :rsi_days => "Day 4", :start_time => "02:00", :st_time_ampm => "pm",
               :end_time => "03:00", :end_time_ampm => "pm", :statements => statement
  @matrix.add_rule :rule_obj => rule
end

Given /^I encure that the AO's Requested Scheduling Information exists on the Final Exam Matrix$/ do
  statement = []
  statement << (make ExamMatrixStatementObject, :days => @activity_offering.days, :start_time => @activity_offering.start_time,
                     :st_time_ampm => @activity_offering.start_time_ampm)
  rule = make ExamMatrixRuleObject, :rsi_days => "Day 4", :start_time => "02:00", :st_time_ampm => "pm",
               :end_time => "03:00", :end_time_ampm => "pm", :statements => statement
  @matrix.add_rule :rule_obj => rule
end

Given /^that the Course Offering has an AO-driven exam that is marked to use the matrix, Requested Scheduling Information for the exam exists on the Final Exam Matrix, and the parent AO of the exam offering has RSI data$/ do
  @original_co = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "HIST111"

  unless @original_co.exists?
    course_offering = make CourseOffering, :term=> Rollover::OPEN_EO_CREATE_TERM,
                           :course => "HIST111",
                           :suffix => ' ',
                           :final_exam_driver => "Final Exam Per Activity Offering"
    course_offering.delivery_format_list[0].format = "Lecture/Discussion"
    course_offering.delivery_format_list[0].grade_format = "Discussion"
    course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
    course_offering.create

    activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                               :format => "Lecture/Discussion", :activity_type => "Lecture"
    si_obj =  make SchedulingInformationObject, :days => "MW",
                   :start_time => "11:00", :start_time_ampm => "am",
                   :end_time => "11:50", :end_time_ampm => "am",
                   :facility => 'JMZ', :room => '0220'
    activity_offering.add_req_sched_info :rsi_obj => si_obj

    #TODO: KSENROLL-13157 problems creating 2nd AO
    # activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
    #                            :format => "Lecture/Discussion", :activity_type => "Discussion"
    # si_obj =  make SchedulingInformationObject, :days => "W",
    #                :start_time => "09:00", :start_time_ampm => "am",
    #                :end_time => "09:50", :end_time_ampm => "am",
    #                :facility => 'KEY', :room => '0117'
    # activity_offering.add_req_sched_info :rsi_obj => si_obj
  end

  @matrix = make FinalExamMatrix, :term_type => "Spring Term"
  @matrix.create_standard_rule_matrix_object_for_rsi( "MW at 11:00 AM")
end

Given /^I manage an AO-driven exam offering with RSI generated from the exam matrix$/ do
  @course_offering = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "HIST110", :final_exam_driver => "Final Exam Per Activity Offering"
  @course_offering.delivery_format_list[0].format = 'Lecture'
  @course_offering.delivery_format_list[0].grade_format = 'Lecture'
  @course_offering.delivery_format_list[0].final_exam_activity = 'Lecture'

  @matrix = make FinalExamMatrix, :term_type => "Spring Term"
  @matrix.create_standard_rule_matrix_object_for_rsi( "MWF at 03:00 PM")

  @course_offering.create
  @activity_offering = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject)
  si_obj =  make SchedulingInformationObject, :days => "MWF",
                 :start_time => "03:00", :start_time_ampm => "pm",
                 :end_time => "03:50", :end_time_ampm => "pm"
  @activity_offering.add_req_sched_info :rsi_obj => si_obj

  @eo_rsi = make EoRsiObject, :ao_driven => true, :ao_code => @activity_offering.code,
                 :day => @matrix.rules[0].rsi_days,
                 :start_time => "#{@matrix.rules[0].start_time} #{@matrix.rules[0].st_time_ampm}",
                 :end_time => "#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm}",
                 :facility =>si_obj.facility, #use AO location is checked on matrix page
                 :room => si_obj.room         #use AO location is checked on matrix page

  on(ManageCourseOfferings).view_exam_offerings
end

Given /^there is an AO-driven exam offering for a course offering in Carol's admin org$/ do
  @course_offering = create CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "ENGL201"
end


Given /^I manage an AO-driven exam offering for a course offering in my admin org$/ do
  @course_offering.manage
  on(ManageCourseOfferings).view_exam_offerings
end

Given /^I manage an AO-driven exam offering with RSI generated from the exam matrix in a term in "Published" SOC state$/ do
  @course_offering = make CourseOffering, :term => Rollover::PUBLISHED_EO_CREATE_TERM, :course => "HIST110", :final_exam_driver => "Final Exam Per Activity Offering"
  @course_offering.delivery_format_list[0].format = 'Lecture'
  @course_offering.delivery_format_list[0].grade_format = 'Lecture'
  @course_offering.delivery_format_list[0].final_exam_activity = 'Lecture'

  @matrix = make FinalExamMatrix, :term_type => "Spring Term"
  @matrix.create_standard_rule_matrix_object_for_rsi( "MWF at 01:00 PM")

  @course_offering.create
  @activity_offering = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject)
  @activity_offering.edit :allow_non_std_timeslots => true, :defer_save => true
  si_obj =  make SchedulingInformationObject, :days => "MWF",
                 :start_time => "01:00", :start_time_ampm => "pm",
                 :end_time => "01:50", :end_time_ampm => "pm"
  @activity_offering.add_req_sched_info :rsi_obj => si_obj, :start_edit => false

  @eo_rsi = make EoRsiObject, :ao_driven => true, :ao_code => @activity_offering.code,
                 :day => @matrix.rules[0].rsi_days,
                 :start_time => "#{@matrix.rules[0].start_time} #{@matrix.rules[0].st_time_ampm}",
                 :end_time => "#{@matrix.rules[0].end_time} #{@matrix.rules[0].end_time_ampm}",
                 :facility =>si_obj.facility, #use AO location is checked on matrix page
                 :room => si_obj.room         #use AO location is checked on matrix page

  on(ManageCourseOfferings).view_exam_offerings
end


Given /^that I copy a Course Offering that has an AO-driven exam that is marked to use the matrix and Requested Scheduling Information for the exam exists on the Final Exam Matrix$/ do
  @course_offering = (make CourseOffering, :term => "201301", :course => "HIST110").copy
  @course_offering.delivery_format_list[0].edit :final_exam_activity => "Discussion"

  @matrix = make FinalExamMatrix, :term_type => "Spring Term"
  statement = []
  statement << (make ExamMatrixStatementObject, :days => "MW", :start_time => "12:00", :st_time_ampm => "pm")
  rule = make ExamMatrixRuleObject, :rsi_days => "Day 1", :start_time => "04:00", :st_time_ampm => "pm",
              :end_time => "05:00", :end_time_ampm => "pm", :statements => statement
  @matrix.add_rule :rule_obj => rule
end

Given /^there is an Activity Offering that has RSI data but has no ASI data$/ do
  @activity_offering = @course_offering.activity_offering_cluster_list[0].ao_list[0]
      # make ActivityOfferingObject, :code => "F", :parent_cluster => @course_offering.default_cluster,
end

Given /^that the Course Offering has an AO-driven exam that is marked to use the matrix and Requested Scheduling Information for the exam does not exist on the Final Exam Matrix$/ do
  @original_co = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "CHEM395"

  unless @original_co.exists?
    course_offering = make CourseOffering, :term=> Rollover::OPEN_EO_CREATE_TERM,
                           :course => "CHEM395",
                           :suffix => ' ',
                           :final_exam_driver => "Final Exam Per Activity Offering"
    course_offering.delivery_format_list[0].format = "Lecture"
    course_offering.delivery_format_list[0].grade_format = "Lecture"
    course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
    course_offering.create

    activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                               :format => "Lecture Only", :activity_type => "Lecture"
    si_obj =  make SchedulingInformationObject, :days => "T",
                   :start_time => "10:00", :start_time_ampm => "am",
                   :end_time => "11:50", :end_time_ampm => "am",
                   :facility => 'CHM', :room => '1402'
    activity_offering.add_req_sched_info :rsi_obj => si_obj
  end

end

Then /^the (?:Requested|Actual) Scheduling Information for the Exam Offering of the AO should be populated$/ do
  on ViewExamOfferings do |page|
    page.ao_eo_days(@activity_offering.code).should match /#{Regexp.escape(@matrix.rules[0].rsi_days)}/i
    page.ao_eo_st_time(@activity_offering.code).should match /#{Regexp.escape(@matrix.rules[0].start_time)}/i
    page.ao_eo_end_time(@activity_offering.code).should match /#{Regexp.escape(@matrix.rules[0].end_time)}/i
  end
end

Then /^the EO's Scheduling Information should change to reflect the updates made to the AO's Actual Scheduling Info$/ do
  on ViewExamOfferings do |page|
    page.ao_eo_days(@activity_offering.code).should match /#{Regexp.escape(@matrix.rules[0].rsi_days)}/i
    page.ao_eo_st_time(@activity_offering.code).should match /#{Regexp.escape(@matrix.rules[0].start_time)}/i
    page.ao_eo_end_time(@activity_offering.code).should match /#{Regexp.escape(@matrix.rules[0].end_time)}/i
  end
end

Then /^the (?:Requested|Actual) Scheduling Information for the Exam Offering of the AO should not be populated$/ do
  on ViewExamOfferings do |page|
    page.ao_eo_days(@activity_offering.code).should == ""
    page.ao_eo_st_time(@activity_offering.code).should == ""
    page.ao_eo_end_time(@activity_offering.code).should == ""
  end
end

Then /^the EO's Scheduling Information for the Exam Offering of the AO should be updated to blank to reflect it was not found on the matrix$/ do
  on ViewExamOfferings do |page|
    page.ao_eo_days(@activity_offering.code).should == ""
    page.ao_eo_st_time(@activity_offering.code).should == ""
    page.ao_eo_end_time(@activity_offering.code).should == ""
  end
end

Given /^that the Course Offering has one Activity Offering with Requested Scheduling Information that exists on the Final Exam Matrix$/ do
  @original_co = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "ENGL313"

  unless @original_co.exists?
    course_offering = make CourseOffering, :term=> Rollover::OPEN_EO_CREATE_TERM,
                           :course => "ENGL313",
                           :suffix => ' ',
                           :final_exam_driver => "Final Exam Per Activity Offering"
    course_offering.delivery_format_list[0].format = "Lecture"
    course_offering.delivery_format_list[0].grade_format = "Lecture"
    course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
    course_offering.create

    activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                               :format => "Lecture Only", :activity_type => "Lecture"
    si_obj =  make SchedulingInformationObject, :days => "TH",
                   :start_time => "03:30", :start_time_ampm => "pm",
                   :end_time => "04:45", :end_time_ampm => "pm",
                   :facility => 'TWS', :room => '0214'
    activity_offering.add_req_sched_info :rsi_obj => si_obj
  end

  @matrix = make FinalExamMatrix, :term_type => "Spring Term"
  @matrix.create_standard_rule_matrix_object_for_rsi( "TH at 03:30 PM")
end

Given /^that the Course Offering has one Activity Offering with Requested Scheduling Information that does not exist on the Final Exam Matrix$/ do
  @original_co = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "ENGL611"

  unless @original_co.exists?
    course_offering = make CourseOffering, :term=>  Rollover::OPEN_EO_CREATE_TERM,
                           :course => "ENGL611",
                           :suffix => ' ',
                           :final_exam_driver => "Final Exam Per Activity Offering"
    course_offering.delivery_format_list[0].format = "Lecture"
    course_offering.delivery_format_list[0].grade_format = "Lecture"
    course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
    course_offering.create

    activity_offering = create ActivityOfferingObject, :parent_cluster => course_offering.default_cluster,
                               :format => "Lecture Only", :activity_type => "Lecture"
    si_obj =  make SchedulingInformationObject, :days => "T",
                   :start_time => "03:30", :start_time_ampm => "pm",
                   :end_time => "06:00", :end_time_ampm => "pm",
                   :facility => 'TWS', :room => '3252'
    activity_offering.add_req_sched_info :rsi_obj => si_obj
  end
end

Given /^I create from catalog a Course Offering with an AO-driven exam that uses the exam matrix in a term with a defined final exam period$/ do
  @matrix = make FinalExamMatrix, :term_type => "Spring Term"
  @matrix.create_standard_rule_matrix_object_for_rsi( "TH at 09:30 AM")

  @course_offering = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "BSCI361",
                            :final_exam_driver => "Final Exam Per Activity Offering"

  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Lecture"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering.create
end

Given /^that the Course Offering has an AO-driven exam that is marked to use the matrix and Actual Scheduling Information for the exam does exist$/ do
  @matrix = make FinalExamMatrix, :term_type => "Fall Term"
  @matrix.create_standard_rule_matrix_object_for_rsi( "TH at 02:00 PM")

  @original_co = engl304_published_eo_create_term

  @course_offering = @original_co.create_from_existing :target_term => Rollover::PUBLISHED_EO_CREATE_TERM

  @course_offering.initialize_with_actual_values
  @activity_offering = @course_offering.activity_offering_cluster_list[0].ao_list[0]
  @activity_offering.edit :send_to_scheduler => true
end

When /^I update the Actual Scheduling Information for the Activity Offering$/ do
  @activity_offering.edit :send_to_scheduler => true, :defer_save => true
  end_time = (DateTime.strptime("#{@matrix.rules[0].statements[0].start_time}", '%I:%M') + ("50".to_f/1440)).strftime( '%I:%M')
  @activity_offering.requested_scheduling_information_list[0].edit :start_time  => @matrix.rules[0].statements[0].start_time,
                                                                   :start_time_ampm  => @matrix.rules[0].statements[0].st_time_ampm,
                                                                   :end_time  => end_time, :end_time_ampm => @matrix.rules[0].statements[0].st_time_ampm
  @activity_offering.save
end

When /^I update the Actual Scheduling Information for the Activity Offering which does not match the Exam Matrix$/ do
  @activity_offering.edit :send_to_scheduler => true, :defer_save => true
  @activity_offering.requested_scheduling_information_list[0].edit :days => "F"
  @activity_offering.save
end

Given /^I manage CO-driven exam offerings for a course offering configured not to use the exam matrix$/ do
  @course_offering = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "CHEM131", :use_final_exam_matrix => false
  @course_offering.create
  on(ManageCourseOfferings).view_exam_offerings

  @eo_rsi = make EoRsiObject, :day => '',
                 :start_time => '',
                 :end_time => '',
                 :facility => '',
                 :room => ''
end

Given /^I manage AO-driven exam offerings for a course offering configured not to use the exam matrix$/ do
  @course_offering = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "HIST110",
                          :final_exam_driver => "Final Exam Per Activity Offering",
                          :use_final_exam_matrix => false
  @course_offering.delivery_format_list[0].format = 'Lecture'
  @course_offering.delivery_format_list[0].grade_format = 'Lecture'
  @course_offering.delivery_format_list[0].final_exam_activity = 'Lecture'

  @course_offering.create

  @activity_offering = @course_offering.create_ao :ao_obj => (make ActivityOfferingObject)
  si_obj =  make SchedulingInformationObject, :days => "MWF",
                 :start_time => "03:00", :start_time_ampm => "pm",
                 :end_time => "03:50", :end_time_ampm => "pm"
  @activity_offering.add_req_sched_info :rsi_obj => si_obj

  @eo_rsi = make EoRsiObject, :ao_driven => true, :ao_code => @activity_offering.code,
                 :on_matrix => false,
                 :day => '',
                 :start_time => '',
                 :end_time => '',
                 :facility =>si_obj.facility, #use AO location is checked on matrix page
                 :room => si_obj.room         #use AO location is checked on matrix page

  on(ManageCourseOfferings).view_exam_offerings
end

When /^the Override Matrix option should not be present$/ do
  on ViewExamOfferings do |page|
    row = page.co_target_row
    page.override_checkbox(row).exists?.should be_false
  end
end

Then /^I am not able to edit the AO-driven exam offering RSI$/ do
  on ViewExamOfferings do |page|
    row = page.ao_eo_target_row('A')
    page.edit_rsi_element(row).present?.should be_false
  end
end

Given /^I manage a course offering with a CO-driven exam offering with RSI generated from the exam matrix where facility and room info are blank$/ do
  @course_offering = create CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "CHEM135"

  @eo_rsi = make EoRsiObject, :day => '',
                 :start_time => '',
                 :end_time => '',
                 :facility => '',
                 :room => ''
end

Given(/^I manage a course offering with an on\-matrix CO\-driven exam offering with no match on the matrix$/) do
  @course_offering = make CourseOffering, :term => Rollover::OPEN_EO_CREATE_TERM, :course => "WMST200", :use_final_exam_matrix => true
  @course_offering.create
  on(ManageCourseOfferings).view_exam_offerings

  @eo_rsi = make EoRsiObject, :day => '',
                 :start_time => '',
                 :end_time => '',
                 :facility => '',
                 :room => '',
                 :sched_state => 'Matrix Error'

end

And(/^the CO RSI is blank and the scheduling state is matrix error$/) do
  on ViewExamOfferings do |page|
    page.co_eo_status.should == @eo_rsi.status
    page.co_eo_sched_state.should == @eo_rsi.sched_state
    page.co_target_row.exists?.should be_true
    page.co_eo_days.should match /#{@eo_rsi.day}/
    page.co_eo_st_time.should == @eo_rsi.start_time
    page.co_eo_end_time.should == @eo_rsi.end_time
    #page.co_eo_bldg.should == @eo_rsi.facility TODO: issue with short vs full facility name
    page.co_eo_room.should == @eo_rsi.room
  end
end

And(/^the AO RSI is blank and the scheduling state is matrix error$/) do
  ao_code = @eo_rsi.ao_code
  on ViewExamOfferings do |page|
    page.ao_eo_target_row(ao_code).exists?.should be_true
    page.ao_eo_status(ao_code).should == 'Draft'
    page.ao_eo_sched_state(ao_code).should == 'Matrix Error'
    page.ao_eo_days(ao_code).should == ''
    page.ao_eo_st_time(ao_code).should == ''
    page.ao_eo_end_time(ao_code).should == ''
    page.ao_eo_bldg(ao_code).should == ''
    page.ao_eo_room(ao_code).should == ''
    page.cancel
  end
end

And(/^the CO-driven EO RSI scheduling state is (.*?)$/) do |expected_state|
  on ViewExamOfferings do |page|
    page.co_target_row.exists?.should be_true
    page.co_eo_sched_state.should == expected_state
  end
end

And(/^the AO-driven EO RSI scheduling state is (.*?)$/) do |expected_state|
  on ViewExamOfferings do |page|
    page.ao_eo_target_row(@activity_offering.code).exists?.should be_true
    page.ao_eo_sched_state(@activity_offering.code).should == expected_state
  end
end

Given(/^I manage a course offering with an on\-matrix AO\-driven exam offering with no match on the matrix$/) do
  @course_offering = make CourseOffering, :term=> Rollover::OPEN_EO_CREATE_TERM,
                         :course => 'WMST210',
                         :final_exam_driver => "Final Exam Per Activity Offering"
  @course_offering.delivery_format_list[0].format = "Lecture"
  @course_offering.delivery_format_list[0].grade_format = "Lecture"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering.create

  @activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                             :format => "Lecture Only", :activity_type => "Lecture"
  si_obj =  make SchedulingInformationObject, :days => "F",
                 :start_time => "11:00", :start_time_ampm => "am",
                 :end_time => "11:50", :end_time_ampm => "am",
                 :facility => 'TWS', :room => '1100'
  @activity_offering.add_req_sched_info :rsi_obj => si_obj

  on(ManageCourseOfferings).view_exam_offerings

  @eo_rsi = make EoRsiObject,:ao_driven => true, :ao_code => @activity_offering.code,
                 :day => '',
                 :start_time => '',
                 :end_time => '',
                 :facility => '',
                 :room => '',
                 :sched_state => 'Matrix Error'

end

When(/^I change the driving AO RSI to match an entry on the final exam matrix$/) do
  @activity_offering.edit :defer_save => true
  @activity_offering.requested_scheduling_information_list[0].edit :days => "MWF", :start_time => "09:00", :start_time_ampm => "am", :end_time => "09:50", :end_time_ampm => "am",
                                                                   :facility => "PHYS", :facility_long_name => "PHYS",:room => "4102"
  @activity_offering.save

  #update according to matrix
  @eo_rsi.day = 'Day 4'
  @eo_rsi.start_time = '08:00 AM'
  @eo_rsi.end_time = '10:00 AM'
  #app set to us AO RSI location
  @eo_rsi.facility = 'PHYS'
  @eo_rsi.room = '4102'
  @eo_rsi.sched_state = 'Unscheduled'
end

When(/^I change the driving AO RSI so it no longer matches an entry on the exam matrix$/) do
  on(ViewExamOfferings).cancel
  @activity_offering.edit :defer_save => true
  @activity_offering.requested_scheduling_information_list[0].edit :days => "SU"
  @activity_offering.save

  #update according to matrix
  @eo_rsi.day = ''
  @eo_rsi.start_time = ''
  @eo_rsi.end_time = ''
  #app set to us AO RSI location
  @eo_rsi.facility = ''
  @eo_rsi.room = ''
  @eo_rsi.sched_state = 'Matrix Error'

  on(ManageCourseOfferings).view_exam_offerings
end

Then(/^the scheduling state for a CO\-driven EO RSI with a matching matrix entry is 'Unscheduled'$/) do
  @course_offering_co_driven_match.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.co_target_row.exists?.should be_true
    page.co_eo_sched_state.should == 'Unscheduled'
  end
end

And(/^the scheduling state for a CO\-driven EO RSI with no matching matrix entry is 'Matrix Error'$/) do
  @course_offering_co_driven.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.co_target_row.exists?.should be_true
    page.co_eo_sched_state.should == 'Matrix Error'
  end
end

Then(/^the scheduling state for a CO-driven EO RSI for a course offering configured to not use the matrix is 'Unscheduled'$/) do
  @course_offering_co_driven_off_matrix.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.co_target_row.exists?.should be_true
    page.co_eo_sched_state.should == 'Unscheduled'
  end
end

And(/^the scheduling state AO\-driven EO RSI with a matching matrix entry is 'Unscheduled'$/) do
  @course_offering_ao_driven.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.ao_eo_target_row('A').exists?.should be_true
    page.ao_eo_sched_state('A').should == 'Unscheduled'
  end
end

And(/^the scheduling state AO\-driven EO RSI with no matching matrix entry is 'Matrix Error'$/) do
  @course_offering_ao_driven.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.ao_eo_target_row('B').exists?.should be_true
    page.ao_eo_sched_state('B').should == 'Matrix Error'
  end
end

And(/^the scheduling state AO\-driven EO RSI with no AO scheduling information is 'Matrix Error'$/) do
  @course_offering_no_rsi.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.ao_eo_target_row('A').exists?.should be_true
    page.ao_eo_sched_state('A').should == 'Matrix Error'
  end
end

And(/^the scheduling state AO-driven EO RSI for a course offering configured to not use the matrix is 'Unscheduled'$/) do
  @course_offering_ao_driven_off_matrix.manage
  on(ManageCourseOfferings).view_exam_offerings
  on ViewExamOfferings do |page|
    page.ao_eo_target_row('A').exists?.should be_true
    page.ao_eo_sched_state('A').should == 'Unscheduled'
    page.ao_eo_target_row('B').exists?.should be_true
    page.ao_eo_sched_state('B').should == 'Unscheduled'
  end
end