When /^I copy an CO with AOs that have ASIs to a new CO in the different term with RSIs in its AOs$/ do
  @source_course_offering = make CourseOffering, :term=> Rollover::SOC_STATES_SOURCE_TERM, :course => "ENGL462"
  @course_offering = @source_course_offering.create_from_existing :target_term=> Rollover::PUBLISHED_SOC_TERM
end

Then /^The new CO and AOs are Successfully created$/ do
  @course_offering.initialize_with_actual_values
  tgt_activity_offering = @course_offering.get_ao_obj_by_code("A")
  tgt_activity_offering.status.should == ActivityOfferingObject::DRAFT_STATUS
  tgt_activity_offering.requested_scheduling_information_list.size.should_not == 0
end

And /^The ASIs are Successfully copied to RSIs in the new AOs of the newly created CO$/ do
  @source_course_offering.initialize_with_actual_values
  source_activity_offering = @source_course_offering.get_ao_obj_by_code("A")
  source_activity_offering.actual_scheduling_information_list.size.should_not == 0

  #now navigate to course offering copy and validate RSIs
  @course_offering.manage
  @course_offering.find_ao_obj_by_code('A').edit :defer_save => true

  on ActivityOfferingMaintenance do |page|
    page.actual_sched_info_div.exists?.should == false  #should not be any ASIs
    page.view_requested_scheduling_information
    page.requested_sched_info_table.rows.size.should be > 1 # should be more than just header row
    page.requested_sched_info_table.rows[1..-1].each do |row|
      days = page.get_requested_sched_info_days(row).delete(' ')
      start_time = page.get_requested_sched_info_start_time(row).delete(' ')
      si_key = "#{days}#{start_time}"
      #get the corresponding ASI by key
      asi = source_activity_offering.actual_scheduling_information_list.by_key(si_key)
      page.get_requested_sched_info_days(row).delete(' ').should == asi.days
      page.get_requested_sched_info_start_time(row).delete(' ').should == "#{asi.start_time}#{asi.start_time_ampm}"
      page.get_requested_sched_info_end_time(row).delete(' ').should == "#{asi.end_time}#{asi.end_time_ampm}"
      page.get_requested_sched_info_facility(row).should == asi.facility_long_name
      page.get_requested_sched_info_room(row).should == asi.room
    end

  end
end





