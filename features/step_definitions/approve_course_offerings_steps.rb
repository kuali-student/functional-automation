When /^I create two new Course Offerings$/ do
  @course_offering_ENGL221 = (make CourseOffering, :term=> Rollover::MAIN_TEST_TERM_TARGET , :course => "ENGL221").copy
  @course_offering_ENGL202 = (make CourseOffering, :term=> Rollover::MAIN_TEST_TERM_TARGET, :course => "ENGL202").copy
end

Given /^I manage a course offering with draft and canceled activity offerings present$/ do
  @course_offering = (make CourseOffering, :term=> "201208", :course => "ENGL221").copy
  @course_offering.initialize_with_actual_values

  @draft_ao = @course_offering.get_ao_obj_by_code("A")
  @canceled_ao = @course_offering.get_ao_obj_by_code("B")
  on ManageCourseOfferings do |page|
    page.ao_status(@draft_ao.code).should == "Draft"
    @canceled_ao.cancel
    page.loading.wait_while_present
    page.ao_status(@canceled_ao.code).should == "Canceled"
  end
end

Given /^I manage a course offering with a canceled activity offering present$/ do
  @course_offering = (make CourseOffering, :term=> "201208", :course => "ENGL221").copy
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("A")
  @activity_offering.cancel
  on ManageCourseOfferings do |page|
    @course_offering.initialize_with_actual_values
    page.loading.wait_while_present
    page.ao_status(@activity_offering.code).should == "Canceled"
  end
end

Given /^I manage a course offering with a canceled activity offering present in draft SOC state$/ do
  @course_offering = (make CourseOffering, :term=> "202000", :course => "ENGL243").copy
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("A")
  @activity_offering.cancel
  on ManageCourseOfferings do |page|
    page.ao_status(@activity_offering.code).should == "Canceled"
  end
end

Given /^I manage a course offering with multiple canceled activity offerings present in draft SOC state$/ do
  @course_offering = (make CourseOffering, :term=> "202000" , :course => "ENGL245").copy
  @course_offering.initialize_with_actual_values

  @canceled_ao1 = @course_offering.get_ao_obj_by_code("A")
  @canceled_ao2 = @course_offering.get_ao_obj_by_code("B")
  #have to put these in canceled status for the test
  @canceled_ao1.cancel
  @canceled_ao2.cancel

  on ManageCourseOfferings do |page|
    page.ao_status(@canceled_ao1.code).should == "Canceled"
    page.ao_status(@canceled_ao2.code).should == "Canceled"
  end
end

Given /^I manage a course offering with canceled and draft activity offerings present in draft SOC state$/ do
  @course_offering = (make CourseOffering, :term=> "202000" , :course => "ENGL245").copy
  @course_offering.initialize_with_actual_values

  @canceled_ao = @course_offering.get_ao_obj_by_code("A")
  #have to put the first in canceled status for the test
  @canceled_ao.cancel

  @draft_ao = @course_offering.get_ao_obj_by_code("B")
  on ManageCourseOfferings do |page|
    page.ao_status(@canceled_ao.code).should == "Canceled"
    page.ao_status(@draft_ao.code).should == "Draft"
  end
end

Given /^I manage a course offering with suspended and offered activity offerings present in a published SOC state$/ do
  @course_offering = (make CourseOffering, :term=> "201208" , :course => "ENGL212").copy
  @course_offering.initialize_with_actual_values

  @suspended_ao = @course_offering.get_ao_obj_by_code("A")
  @suspended_ao.edit :send_to_scheduler => true
  @offered_ao = @course_offering.get_ao_obj_by_code("B")
  @offered_ao.edit :send_to_scheduler => true
  @suspended_ao.suspend
  on ManageCourseOfferings do |page|
    page.ao_status(@suspended_ao.code).should == "Suspended"
    page.ao_status(@offered_ao.code).should == "Offered"
  end
end

Given /^I suspend two activity offerings in offered status for a course offering in a published SOC state$/ do
  @course_offering = (make CourseOffering, :term=> "201208" , :course => "HIST355").copy
  @course_offering.initialize_with_actual_values

  @draft_ao = @course_offering.get_ao_obj_by_code("A")
  @suspended_ao = @course_offering.copy_ao :ao_code => @draft_ao.code
  @suspended_ao2 = @course_offering.copy_ao :ao_code => @draft_ao.code
  @suspended_ao.approve :send_to_scheduler => true
  @suspended_ao2.approve :send_to_scheduler => true

  @suspended_ao.suspend
  @suspended_ao2.suspend

  on ManageCourseOfferings do |page|
    page.ao_status(@suspended_ao.code).should == "Suspended"
    page.ao_status(@suspended_ao2.code).should == "Suspended"
  end
end

Given /^I suspend two draft activity offerings for a course offering in a published SOC state$/ do
  @course_offering = (make CourseOffering, :term=> "201208" , :course => "HIST355").copy
  @course_offering.initialize_with_actual_values

  @draft_ao = @course_offering.get_ao_obj_by_code("A")
  @suspended_ao = @course_offering.copy_ao :ao_code => @draft_ao.code
  @suspended_ao2 = @course_offering.copy_ao :ao_code => @draft_ao.code

  @suspended_ao.suspend
  @suspended_ao2.suspend

  on ManageCourseOfferings do |page|
    page.ao_status(@suspended_ao.code).should == "Suspended"
    page.ao_status(@suspended_ao2.code).should == "Suspended"
  end
end

Given /^I manage a course offering with a suspended and a draft activity offering present in a published SOC state$/ do
  @course_offering = (make CourseOffering, :term=> "201208", :course => "HIST232").copy
  @course_offering.initialize_with_actual_values

  @draft_ao = @course_offering.get_ao_obj_by_code("A")
  on ManageCourseOfferings do |page|
    page.copy(@draft_ao.code)
    page.loading.wait_while_present
    @suspended_ao = @course_offering.get_ao_obj_by_code("B")
    @suspended_ao.suspend
    @course_offering.initialize_with_actual_values
    page.loading.wait_while_present
    page.ao_status(@suspended_ao.code).should == "Suspended"
    page.ao_status(@draft_ao.code).should == "Draft"
  end
end

Given /^a new academic term has course and activity offerings in canceled and suspended status$/ do
  @calendar = create AcademicCalendar #, :year => "2235", :name => "fSZtG62zfU"
  term = make AcademicTermObject, :parent_calendar => @calendar
  @calendar.add_term term

  @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
  @manage_soc.set_up_soc
  @manage_soc.perform_manual_soc_state_change

  @course_offering_canceled = make CourseOffering, :term=> @calendar.terms[0].term_code,
                                     :course => "ENGL211"
  @course_offering_canceled.delivery_format_list[0].format = "Lecture"
  @course_offering_canceled.delivery_format_list[0].grade_format = "Lecture"
  @course_offering_canceled.delivery_format_list[0].final_exam_activity = "Lecture"

  @course_offering_canceled.create

  @activity_offering_canceled = create ActivityOfferingObject, :parent_cluster => @course_offering_canceled.default_cluster,
                                       :activity_type => "Lecture"
  @activity_offering_canceled.cancel :navigate_to_page => false

  @course_offering_suspended = make CourseOffering, :term=> @calendar.terms[0].term_code,
                                      :course => "ENGL211"
  @course_offering_suspended.delivery_format_list[0].format = "Lecture"
  @course_offering_suspended.delivery_format_list[0].grade_format = "Lecture"
  @course_offering_suspended.delivery_format_list[0].final_exam_activity = "Lecture"
  @course_offering_suspended.create

  @activity_offering_suspended = create ActivityOfferingObject, :parent_cluster => @course_offering_suspended.default_cluster,
                                        :activity_type => "Lecture"

  @activity_offering_suspended.approve :navigate_to_page => false
  @manage_soc.advance_soc_from_open_to_final_edits
  @activity_offering_suspended.suspend
end

Then /^I am (able|not able) to cancel the activity offering$/ do  |can_cancel|
  @activity_offering.manage_parent_co
  on ManageCourseOfferings do |page|
    page.select_ao(@activity_offering.code)
    if can_cancel == "able"
      page.cancel_ao_button.enabled?.should be_true
    else
      page.cancel_ao_button.enabled?.should be_false
    end
    page.deselect_ao(@activity_offering.code)
  end
end

Then /^I am (able|not able) to suspend the activity offering$/ do |can_suspend|
  @activity_offering.manage_parent_co
  on ManageCourseOfferings do |page|
      page.select_ao(@activity_offering.code)
      if can_suspend == "able"
        page.suspend_ao_button.enabled?.should be_true
      else
        page.suspend_ao_button.enabled?.should be_false
      end
      page.deselect_ao(@activity_offering.code)
    end
end

Then /^I am (able|not able) to reinstate the activity offering$/ do |can_suspend|
  @activity_offering.manage_parent_co
  on ManageCourseOfferings do |page|
    page.select_ao(@activity_offering.code)
    if can_suspend == "able"
      page.reinstate_ao_button.enabled?.should be_true
      @activity_offering.reinstate :navigate_to_page => false
      on(ManageCourseOfferings).ao_status(@activity_offering.code).should == "Draft"
    else
      page.reinstate_ao_button.enabled?.should be_false
    end
    page.deselect_ao(@activity_offering.code)
  end
end


Then /^I(?: can)? suspend the activity offering$/ do
  @activity_offering.suspend

  on ManageCourseOfferings do |page|
    page.growl_text.should == "The selected activity offering was successfully suspended."
    page.ao_status(@activity_offering.code).should == "Suspended"
  end

end

Then /^I(?: can)? cancel the activity offering$/ do
  @activity_offering.cancel

  on ManageCourseOfferings do |page|
    page.growl_text.should == "The selected activity offering was successfully canceled."
    page.ao_status(@activity_offering.code).should == "Canceled"
  end

end

When /^I reinstate the activity offerings$/ do
  @canceled_ao1.reinstate
  @canceled_ao2.reinstate
end

When /^I reinstate both activity offerings$/ do
  @course_offering.reinstate_ao_list :ao_obj_list => [@suspended_ao, @suspended_ao2]
end

Then /^I am able to cancel the draft activity offering$/ do
  # also want to check proper activation of button & that selection of ineligible AO gives warning msg.
  on ManageCourseOfferings do |page|
    page.select_ao(@canceled_ao.code)
    page.cancel_ao_button.enabled?.should be_false
    page.select_ao(@draft_ao.code)
    page.cancel_ao_button.enabled?.should be_true
    page.cancel_ao
  end

  on CancelActivityOffering do |page|
    page.warning_msg_present("1 activity offering(s) will be canceled").should == true
    page.warning_msg_present("1 activity offering(s) cannot be canceled (ineligible status)").should == true
    page.cancel_activity
  end

  on ManageCourseOfferings do |page|
    page.loading.wait_while_present
    page.ao_status(@draft_ao.code).should == "Canceled"
  end
end

When /^I reinstate the activity offering$/ do
  @activity_offering.reinstate :navigate_to_page => false
end


When /^I reinstate the activity offerings, receiving a warning message that one of the two selections is eligible for this action$/ do
  on ManageCourseOfferings do |page1|
    page1.cluster_select_all_aos()
    page1.reinstate_ao
  end
  on ReinstateActivityOffering do |page2|
    page2.warning_msg_present("activity offering(s) will be reinstated").should == true
    page2.warning_msg_present("activity offering(s) cannot be reinstated (ineligible status)").should == true
    page2.reinstate_activity
  end
end

When /^I reinstate both activity offerings, receiving a warning message that one of the two selections is eligible for this action$/ do
  on(ManageCourseOfferings) do |page1|
    page1.select_ao(@suspended_ao.code)
    page1.select_ao(@draft_ao.code)
    page1.reinstate_ao
  end
  on ReinstateActivityOffering do |page2|
    page2.warning_msg_present("1 activity offering(s) will be reinstated").should == true
    page2.warning_msg_present("1 activity offering(s) cannot be reinstated (ineligible status)").should == true
    page2.reinstate_activity
  end
end

Then /^the activity offering is shown as draft$/ do
  on ManageCourseOfferings do |page|
    page.ao_status(@activity_offering.code).should == "Draft"
  end
end

Then /^the activity offering is in offered status$/ do
  on(ManageCourseOfferings).ao_status(@activity_offering.code).should == "Offered"
end

Then /^the activity offering is in approved status$/ do
  on(ManageCourseOfferings).ao_status(@activity_offering.code).should == "Approved"
end


Then /^the Suspended activity offering is shown as draft$/ do
  on ManageCourseOfferings do |page|
    page.ao_status(@activity_offering.code).should == "Draft"
  end
end

Then /^the Suspended activity offering is shown as draft and the draft activity offering is shown as draft$/ do
  on ManageCourseOfferings do |page|
    page.ao_status(@suspended_ao.code).should == "Draft"
    page.ao_status(@draft_ao.code).should == "Draft"
  end
end

Then /^both Suspended activity offerings are shown as draft$/ do
  on ManageCourseOfferings do |page|
    page.ao_status(@suspended_ao.code).should == "Draft"
    page.ao_status(@suspended_ao2.code).should == "Draft"
  end
end

Then /^the Suspended activity offerings are shown as offered$/ do
  on ManageCourseOfferings do |page|
    page.ao_status(@suspended_ao.code).should == "Offered"
    page.ao_status(@suspended_ao2.code).should == "Offered"
  end
end

Then /^the Canceled activity offerings are shown as draft$/ do
  on ManageCourseOfferings do |page|
    page.ao_status(@canceled_ao1.code).should == "Draft"
    page.ao_status(@canceled_ao2.code).should == "Draft"
  end
end

Then /^the Canceled and Draft activity offerings are both shown as draft$/ do
  on ManageCourseOfferings do |page|
    page.ao_status(@canceled_ao.code).should == "Draft"
    page.ao_status(@draft_ao.code).should == "Draft"
  end
end

Then /^the Suspended and Offered activity offerings are both shown as offered$/ do
  on ManageCourseOfferings do |page|
    page.ao_status(@suspended_ao.code).should == "Offered"
    page.ao_status(@offered_ao.code).should == "Offered"
  end
end

And /^the Course Offering is shown as Canceled$/ do
  on ManageCourseOfferings do |page1|
    page1.list_all_courses
  end
    on ManageCourseOfferingList do |page2|
      page2.co_status(@course_offering.course).should == "Canceled"
    end
end

Then /^the Course Offering is shown as Draft$/ do
  on ManageCourseOfferings do |page1|
    page1.list_all_courses
    on ManageCourseOfferingList do |page2|
      page2.co_status(@course_offering.course).should == "Draft"
    end
  end
end

Then /^the Course Offering is shown as Offered$/ do
  on ManageCourseOfferings do |page1|
    page1.list_all_courses
    on ManageCourseOfferingList do |page2|
      page2.co_status(@course_offering.course).should == "Offered"
    end
  end
end

Then /^the Course Offering is shown as Planned$/ do
  on ManageCourseOfferings do |page1|
    page1.list_all_courses
    on ManageCourseOfferingList do |page2|
      page2.co_status(@course_offering.course).should == "Planned" #TODO: use the object here
    end
  end
end

Then /^the Course Offering is now shown as Planned$/ do
  on ManageCourseOfferings do |page1|
    page1.list_all_courses
    on ManageCourseOfferingList do |page2|
      page2.co_status(@course_offering.course).should == "Planned"
    end
  end
end

Given /^I manage a course offering with a draft activity offering$/ do
  @term_for_test = Rollover::OPEN_SOC_TERM if @term_for_test.nil?
  @course_offering = (make CourseOffering, :term=> @term_for_test, :course => "HIST240").copy
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("A")
  @activity_offering.status.should == "Draft"
end

Given /^I manage a course offering with an approved activity offering present$/ do
  @term_for_test = "201208" if @term_for_test.nil?
  @course_offering = (make CourseOffering, :term=> @term_for_test , :course => "ENGL295").copy
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("A")
  @activity_offering.edit :send_to_scheduler => true

  on ManageCourseOfferings do |page|
    page.ao_status(@activity_offering.code).should == "Offered"
  end
end

 Given /^I manage a course offering with an offered activity offering present$/ do
  @term_for_test = "201208" if @term_for_test.nil?
  @course_offering = (make CourseOffering, :term=> @term_for_test , :course => "ENGL295").copy
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("A")
  @activity_offering.edit :send_to_scheduler => true

  on ManageCourseOfferings do |page|
    page.ao_status(@activity_offering.code).should == "Offered"
  end
end

Given /^an activity offering in draft status (can|cannot) be suspended$/ do |can_suspend|
  @term_for_test = Rollover::OPEN_SOC_TERM unless @term_for_test != nil
  @course_offering = make CourseOffering, :term=> @term_for_test, :course => "HIST357"
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.ao_status("A").should == "Draft"
    page.select_ao("A")
    case can_suspend
      when "cannot"
        page.suspend_ao_button.enabled?.should be_false
      else  # "can"
        page.suspend_ao_button.enabled?.should be_true
    end
    page.deselect_ao("A")
  end
end

Given /^the activity offering (can|cannot) be reinstated$/ do |can_reinstate|
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.select_ao("A")
    case can_reinstate
      when "cannot"
        page.reinstate_ao_button.enabled?.should be_false
      else  # "can"
        page.reinstate_ao_button.enabled?.should be_true
    end
    page.deselect_ao("A")
  end
end

Given /^I manage a course offering with an approved activity offering$/ do
  @term_for_test = Rollover::OPEN_SOC_TERM if @term_for_test.nil?
  @course_offering = (make CourseOffering, :term=> @term_for_test, :course => "ENGL362").copy
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("A")
  @activity_offering.approve :navigate_to_page => false, :send_to_scheduler => true

  on(ManageCourseOfferings).ao_status(@activity_offering.code).should == "Offered"
end

Then /^the activity offering copy is in draft status$/ do
  on ManageCourseOfferings do |page|
    page.ao_status(@activity_offering_copy.code).should == "Draft"
  end
end

Given /^I manage a course offering with an activity offering in canceled status$/ do
  @term_for_test = Rollover::OPEN_SOC_TERM if @term_for_test.nil?
  @course_offering = (make CourseOffering, :term=> @term_for_test, :course => "ENGL362").copy
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("A")
  @activity_offering.cancel :navigate_to_page => false

  on(ManageCourseOfferings).ao_status(@activity_offering.code).should == "Canceled"
end

Given /^there is an existing course offering with an activity offering in canceled status$/ do
  @course_offering = make CourseOffering, :term=> "201208", :course => "ENGL221"
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("B")

  on(ManageCourseOfferings).ao_status(@activity_offering.code).should == "Canceled"
end

Given /^the canceled activity offering copy is in draft status$/ do
  @course_offering_copy.manage

  on(ManageCourseOfferings).ao_status(@activity_offering.code).should == "Draft"
end

Given /^I copy a course offering in canceled status$/ do
  source_co = (make CourseOffering, :term=> "201208", :course => "BSCI181").copy

  source_ao = make ActivityOfferingObject, :code => 'A', :parent_cluster => source_co.default_cluster
  source_ao.cancel

  source_co.search_by_subjectcode
  on ManageCourseOfferingList do |page|
    page.co_status(source_co.course).should == "Canceled"
  end

  @course_offering = source_co.copy
end

Given /^I copy a course offering in suspended status$/ do
  course_offering_suspended = (make CourseOffering, :term=> "201208" , :course => "BSCI121").copy
  course_offering_suspended.initialize_with_actual_values

  @activity_offering = course_offering_suspended.get_ao_obj_by_code("A")
  @activity_offering.suspend
  course_offering_suspended.search_by_subjectcode

  on(ManageCourseOfferingList).co_status(course_offering_suspended.course).should == "Suspended"
  @course_offering = course_offering_suspended.copy
end

Given /^the course offering copy is in draft status$/ do
  @course_offering.search_by_subjectcode

  on ManageCourseOfferingList do |page|
    page.co_status(@course_offering.course).should == "Draft"
  end
end

Given /^I create a course offering from catalog with a suspended activity offering$/ do
  @term_for_test = Rollover::OPEN_SOC_TERM if @term_for_test.nil?

  @course_offering = make CourseOffering, :term=> @term_for_test,
                            :course => "CHEM132"
  @course_offering.delivery_format_list[0].format = "Lab"
  @course_offering.delivery_format_list[0].grade_format = "Lab"
  @course_offering.delivery_format_list[0].final_exam_activity = "Lab"
  @course_offering.create

  @activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                              :format => "Lab Only", :activity_type => "Lab"

  @activity_offering.suspend :navigate_to_page => false
  on(ManageCourseOfferings).ao_status(@activity_offering.code).should == "Suspended"
end

Given /^I add requested scheduling information to the activity offering$/ do
  @activity_offering.add_req_sched_info :rsi_obj => (make SchedulingInformationObject, :days => "MWF"), :defer_save => true
end

Given /^I am able to send the activity offering to the scheduler$/ do
  @activity_offering.edit :send_to_scheduler => true, :start_edit => false
end

And /^actual scheduling information for the activity offering are still shown$/ do
  on(ManageCourseOfferings).view_activity_offering(@activity_offering.code)
  on ActivityOfferingInquiry do |page|
    page.actual_scheduling_information_days.present?.should be_true
    page.close
  end
end

Given /^the actual scheduling information are displayed for the updated activity offering$/ do
  @activity_offering.manage_parent_co
   expected_asi = @activity_offering.requested_scheduling_information_list[0]
  on ManageCourseOfferings do |page|
    page.target_row(@activity_offering.code).cells[ManageCourseOfferings::AO_DAYS].text.should == expected_asi.days
    page.target_row(@activity_offering.code).cells[ManageCourseOfferings::AO_ST_TIME].text.should == "#{expected_asi.start_time} #{expected_asi.start_time_ampm.upcase}"
    page.target_row(@activity_offering.code).cells[ManageCourseOfferings::AO_END_TIME].text.should == "#{expected_asi.end_time} #{expected_asi.end_time_ampm.upcase}"
    page.target_row(@activity_offering.code).cells[ManageCourseOfferings::AO_BLDG].text.should == expected_asi.facility
    page.target_row(@activity_offering.code).cells[ManageCourseOfferings::AO_ROOM].text.should == expected_asi.room
  end
end


Given /^I manage a course offering with a canceled activity offering$/ do
  @term_for_test = Rollover::OPEN_SOC_TERM unless @term_for_test != nil
  @course_offering = (make CourseOffering, :term=> @term_for_test, :course => "ENGL362").copy
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("A")
  @activity_offering.cancel :navigate_to_page => false

  on(ManageCourseOfferings).ao_status(@activity_offering.code).should == "Canceled"
end

Given /^I manage a course offering with a suspended activity offering$/ do
  @term_for_test = "201208" if @term_for_test.nil?
  @course_offering = (make CourseOffering, :term=> @term_for_test, :course => "ENGL222").copy
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("A")
  @activity_offering.suspend :navigate_to_page => false

  on(ManageCourseOfferings).ao_status(@activity_offering.code).should == "Suspended"
end


And /^actual scheduling information for the Suspended activity offering are no longer shown$/ do
  on(ManageCourseOfferings).view_activity_offering(@activity_offering.code)
  on ActivityOfferingInquiry do |page|
    page.actual_scheduling_information_days.present?.should be_false
    page.close
  end
end

And /^actual scheduling information for the activity offering are no longer shown$/ do
  on(ManageCourseOfferings).view_activity_offering(@activity_offering.code)
  on ActivityOfferingInquiry do |page|
    page.actual_scheduling_information_days.present?.should be_false
    page.close
  end
end

And /^actual scheduling information for the first Suspended activity offering are still shown$/ do
  on(ManageCourseOfferings).view_activity_offering(@suspended_ao.code)
  on ActivityOfferingInquiry do |page|
    page.actual_scheduling_information_days.present?.should be_true
    page.close
  end
end

And /^actual scheduling information for the Suspended activity offering are still shown$/ do
  on(ManageCourseOfferings).view_activity_offering(@suspended_ao.code)
  on ActivityOfferingInquiry do |page|
    page.actual_scheduling_information_days.present?.should be_true
    page.close
  end
end

And /^actual scheduling information for the Offered activity offering are still shown$/ do
  on(ManageCourseOfferings).view_activity_offering(@offered_ao.code)
  on ActivityOfferingInquiry do |page|
    page.actual_scheduling_information_days.present?.should be_true
    page.close
  end
end

And /^actual scheduling information for the second Suspended activity offering are still shown$/ do
  on(ManageCourseOfferings).view_activity_offering(@suspended_ao2.code)
  on ActivityOfferingInquiry do |page|
    page.actual_scheduling_information_days.present?.should be_true
    page.close
  end
end

And /^actual scheduling information for the Approved activity offering are still shown$/ do
  on(ManageCourseOfferings).view_activity_offering(@activity_offering.code)
  on ActivityOfferingInquiry do |page|
    page.actual_scheduling_information_days.present?.should be_true
    page.close
  end
end

And /^requested scheduling information are still shown and actual scheduling information are not shown for the activity offering$/ do
  on(ManageCourseOfferings).view_activity_offering(@activity_offering.code)
  on ActivityOfferingInquiry do |page|
    page.requested_scheduling_information_days.present?.should be_true
    page.actual_scheduling_information_days.present?.should be_false
    page.close
  end
end

And /^requested scheduling information are still shown and actual scheduling information are not shown for the second activity offering$/ do
  on(ManageCourseOfferings).view_activity_offering(@suspended_ao.code)
  on ActivityOfferingInquiry do |page|
    page.requested_scheduling_information_days.present?.should be_true
    page.actual_scheduling_information_days.present?.should be_false
    page.close
  end
end

And /^requested scheduling information are still shown and actual scheduling information are not shown for the third activity offering$/ do
  on(ManageCourseOfferings).view_activity_offering(@suspended_ao2.code)
  on ActivityOfferingInquiry do |page|
    page.requested_scheduling_information_days.present?.should be_true
    page.actual_scheduling_information_days.present?.should be_false
    page.close
  end
end

And /^requested scheduling information are still shown and actual scheduling information are not shown for both activity offerings$/ do
  on(ManageCourseOfferings).view_activity_offering(@canceled_ao1.code)
  on ActivityOfferingInquiry do |page|
    page.requested_scheduling_information_days.present?.should be_true
    page.actual_scheduling_information_days.present?.should be_false
    page.close
  end
  @course_offering.manage
  on(ManageCourseOfferings).view_activity_offering(@canceled_ao2.code)
  on ActivityOfferingInquiry do |page|
    page.requested_scheduling_information_days.present?.should be_true
    page.actual_scheduling_information_days.present?.should be_false
    page.close
  end
end

And /^requested scheduling information are still shown and actual scheduling information are not shown for the Canceled activity offering$/ do
  on(ManageCourseOfferings).view_activity_offering(@canceled_ao.code)
  on ActivityOfferingInquiry do |page|
    page.requested_scheduling_information_days.present?.should be_true
    page.actual_scheduling_information_days.present?.should be_false
    page.close
  end
end

And /^the registration group is shown as canceled$/ do
  on ManageCourseOfferings do |page|
    if page.view_reg_groups_table().present? == false
      page.view_cluster_reg_groups()
    end
    page.view_reg_groups_table().rows[1].cells[1].text.should == "Canceled"
  end
end

And /^the registration group is shown as offered$/ do
  on ManageCourseOfferings do |page|
    if page.view_reg_groups_table().present? == false
      page.view_cluster_reg_groups()
    end
    page.target_reg_group_row(@activity_offering.code).cells[1].text.should == "Offered"
  end
end

And /^both registration groups are shown as offered$/ do
  on ManageCourseOfferings do |page|
    if page.view_reg_groups_table().present? == false
      page.view_cluster_reg_groups()
    end
    page.target_reg_group_row(@suspended_ao.code).cells[1].text.should == "Offered"
    page.target_reg_group_row(@suspended_ao2.code).cells[1].text.should == "Offered"
  end
end

And /^the(?: related)? registration group is shown as pending$/ do
  on ManageCourseOfferings do |page|
    if page.view_reg_groups_table().present? == false
      page.view_cluster_reg_groups()
    end
    page.target_reg_group_row(@activity_offering.code).cells[1].text.should == "Pending"
  end
end

And /^registration group is shown as pending$/ do
  on ManageCourseOfferings do |page|
    if page.view_reg_groups_table().present? == false  #TODO: can set up the method where the first RG is the default
      page.view_cluster_reg_groups()
    end
    page.view_reg_groups_table().rows[1].cells[1].text.should == "Pending"
  end
end

And /^all associated registration group are shown as pending$/ do
  on ManageCourseOfferings do |page|
    if page.view_reg_groups_table().present? == false
      page.view_cluster_reg_groups()
    end
    page.view_reg_groups_table().rows[2].cells[1].text.should == "Pending"
    page.view_reg_groups_table().rows[3].cells[1].text.should == "Pending"
  end
end

And /^the Suspended activity offering is no longer shown in the Schedule of Classes$/ do
  go_to_display_schedule_of_classes
  @schedule_of_classes = make ScheduleOfClasses, :term => "Fall 2012", :course_search_parm => @course_offering.course, :exp_course_list => [@course_offering.course]
  @schedule_of_classes.display
  on DisplayScheduleOfClasses do |page|
    if !page.course_not_found_info_message_div.ul.exists?
      if page.get_results_course_list.include?(@course_offering.course)
        # course not listed - that's fine
      else
        # check the listing for the specific AO
        @schedule_of_classes.expand_course_details
        if !page.results_activities_table.exists?
          raise "activities table not found"
        else
          page.results_activities_table.rows[1..-1].each do |row|
            # check only rows with data in them
            row.cells[DisplayScheduleOfClasses::AO_CODE_COLUMN].text.should_not == @activity_offering.code
          end
        end
      end
    end
  end
end

And /^the Course Offering is no longer shown in the Schedule of Classes$/ do
  course_code = @course_offering.course
  go_to_display_schedule_of_classes
  @schedule_of_classes = make ScheduleOfClasses, :term => "Fall 2012", :course_search_parm => course_code, :exp_course_list => [course_code]
  @schedule_of_classes.display
  on DisplayScheduleOfClasses do |page|
    # if the message (Cannot find any course offering...) is there, we're good; otherwise, check the table
    if !page.course_not_found_info_message_div.ul.exists?
      if page.get_results_course_list.include?(course_code)
        raise "course #{course_code} found in results table"
      end
    end
  end
end

And /^I approve the two Course Offerings for scheduling$/ do
  @course_offering_ENGL221.approve_co_list :co_obj_list => [@course_offering_ENGL221,@course_offering_ENGL202]
end

When /^I manage a Course Offering$/ do
#to make each scenario independent, we make a new co
  @course_offering = (make CourseOffering, :term=> Rollover::MAIN_TEST_TERM_TARGET, :course => "ENGL202").copy
end

And /^I approve the Course Offering for scheduling$/ do
  @course_offering.approve_co
end

And /^I approve selected Activity Offerings for scheduling$/ do
  @course_offering.initialize_with_actual_values
  @selected_ao_list =  @course_offering.activity_offering_cluster_list[0].ao_list[0..1]
  @course_offering.approve_ao_list(:ao_obj_list => @selected_ao_list)
end

Then /^the Activity Offerings of these two COs should be in Approved state$/ do
  @course_offering_ENGL221.initialize_with_actual_values
  new_cluster_list = @course_offering_ENGL221.activity_offering_cluster_list
  ao_list = @course_offering_ENGL221.get_ao_list
  #ao_list = new_cluster_list[0].ao_list
  ao_list.each do |ao|
    on ManageCourseOfferings do |page|
      page.ao_status(ao.code).should == ActivityOfferingObject::APPROVED_STATUS
    end
  end
  @course_offering_ENGL202.initialize_with_actual_values
  #new_cluster_list = @course_offering_ENGL202.activity_offering_cluster_list
  ao_list = @course_offering_ENGL202.get_ao_list
  ao_list.each do |ao|
    on ManageCourseOfferings do |page|
      page.ao_status(ao.code).should == ActivityOfferingObject::APPROVED_STATUS
    end
  end
end

Then /^the Activity Offerings should be in Approved state$/ do
  @course_offering.initialize_with_actual_values
  @course_offering.get_ao_list.each do |ao|
    on ManageCourseOfferings do |page|
      page.ao_status(ao.code).should == ActivityOfferingObject::APPROVED_STATUS
    end
  end
end

Then /^the selected Activity Offerings should be in Approved state$/ do
  @course_offering.manage
  @selected_ao_list.each do |ao|
    on ManageCourseOfferings do |page|
      page.ao_status(ao.code).should == ActivityOfferingObject::APPROVED_STATUS
    end
  end
end

Given /^I manage a course offering with a colocated activity offering$/ do
  @course_offering = make CourseOffering, :term => "201208", :course => "CHEM441"
  @course_offering.initialize_with_actual_values

  @activity_offering = @course_offering.get_ao_obj_by_code("A")
  @activity_offering.status.should == "Offered"

  on ManageCourseOfferings do |page|
    page.target_row(@activity_offering.code)[1].image(src: /colocate_icon/).present?.should be_true
  end
end

Then /^I am unable submit the activity offering to the scheduler$/ do
  @activity_offering.edit :defer_save => true

  on ActivityOfferingMaintenance do |page|
    page.cannot_send_to_scheduler_msg_exists.should be_true
    page.cancel
  end
end


Then /^I am unable to colocate the activity offering$/ do
  @activity_offering.edit :defer_save => true

  on ActivityOfferingMaintenance do |page|
    page.colocated_checkbox.enabled?.should be_false
    page.cancel
  end
end

Then /^the course and activity offerings in the rollover target term are in draft status$/ do
  @course_offering_suspended_target = make CourseOffering, :term=> @calendar_target.terms[0].term_code,
                                 :course => @course_offering_suspended.course
  @course_offering_suspended_target.manage
  on ManageCourseOfferings do |page|
    page.ao_status(@activity_offering_suspended.code).should == "Draft"
  end

  @course_offering_canceled_target = make CourseOffering, :term=> @calendar_target.terms[0].term_code,
                                           :course => @course_offering_canceled.course
  @course_offering_canceled_target.manage
  on ManageCourseOfferings do |page|
    page.ao_status(@activity_offering_canceled.code).should == "Draft"
  end

  @course_offering_canceled_target.search_by_subjectcode
  on ManageCourseOfferingList do |page|
    page.co_status(@course_offering_canceled_target.course).should == "Draft"
    page.co_status(@course_offering_suspended_target.course).should == "Draft"
  end
end

Given /^a new academic term has an activity offering in approved status$/ do
    @calendar = create AcademicCalendar #, :year => "2235", :name => "fSZtG62zfU"
    term = make AcademicTermObject, :parent_calendar => @calendar
    @calendar.add_term term

    exam_period = make ExamPeriodObject, :parent_term => term, :start_date=>"12/11/#{@calendar.year}",
                       :end_date=>"12/20/#{@calendar.year}"
    @calendar.terms[0].add_exam_period exam_period
    @calendar.terms[0].save

    @manage_soc = make ManageSoc, :term_code => @calendar.terms[0].term_code
    @manage_soc.set_up_soc
    @manage_soc.perform_manual_soc_state_change

    @course_offering = make CourseOffering, :term=> @calendar.terms[0].term_code,
                                :course => "ENGL462"
    @course_offering.delivery_format_list[0].format = "Lecture"
    @course_offering.delivery_format_list[0].grade_format = "Lecture"
    @course_offering.delivery_format_list[0].final_exam_activity = "Lecture"
    @course_offering.create

    @activity_offering = create ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster,
                                         :format => "Lecture Only", :activity_type => "Lecture"
    @activity_offering.approve
end