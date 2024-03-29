Then /^the registration groups are automatically generated$/ do
  #TODO - implement using validation of reg group counts
  #@course_offering_copy.activity_offering_cluster_list.each do |cluster|
  #  on ManageCourseOfferings do |page|
  #    page.get_cluster_status_msg(cluster.private_name).strip.should  match /.*All Registration Groups Generated.*/
  #  end
  #end
end

Then /^the activity offering clusters? and assigned AOs are copied over with the course offering$/ do
  @course_offering_copy.manage

  on ManageCourseOfferings do |page|
    clusters = page.cluster_div_list
    clusters.length.should == @course_offering_copy.activity_offering_cluster_list.length
  end

  @course_offering_copy.activity_offering_cluster_list.each do |cluster|
    on ManageCourseOfferings do |page|
      actual_aos = page.get_cluster_assigned_ao_list(cluster.private_name)
      actual_aos.sort.should == cluster.ao_code_list.sort
    end
  end
end

Then /^the activity offering clusters?, assigned AOs and reg groups are rolled over with the course offering$/ do
  @course_offering_copy = make CourseOffering, :course=>@course_offering.course, :term=>Rollover::ROLLOVER_TEST_TERM_TARGET
  @course_offering_copy.activity_offering_cluster_list = @course_offering.activity_offering_cluster_list.sort
  @course_offering_copy.manage   #NB, in this case can never be initialize_with_actual_values

  on ManageCourseOfferings do |page|
    clusters = page.cluster_div_list
    clusters.length.should == @course_offering_copy.activity_offering_cluster_list.length
  end

  @course_offering_copy.activity_offering_cluster_list.each do |cluster|
    on ManageCourseOfferings do |page|
      actual_aos = page.get_cluster_assigned_ao_list(cluster.private_name)
      actual_aos.sort.should == cluster.ao_code_list.sort
    end
  end
end

Then /^the activity offering scheduling information are copied to the rollover term as requested scheduling information$/ do
  @course_offering_copy = make CourseOffering, :course=>@course_offering.course, :term=>Rollover::ROLLOVER_TEST_TERM_TARGET

  @course_offering.initialize_with_actual_values
  source_activity_offering = @course_offering.find_ao_obj_by_code("G")
  source_activity_offering.requested_scheduling_information_list.size.should_not == 0

  #now navigate to course offering copy and validate RSIs
  @course_offering_copy.manage
  on(ManageCourseOfferings).edit(source_activity_offering.code, source_activity_offering.parent_cluster.private_name)

  on ActivityOfferingMaintenance do |page|
    page.actual_sched_info_div.exists?.should == false  #should not be any ASIs
    page.requested_sched_info_table.rows.size.should be > 1 # should be more than just header row
    page.requested_sched_info_table.rows[1..-1].each do |row|
      days = page.get_requested_sched_info_days(row).delete(' ')
      start_time = page.get_requested_sched_info_start_time(row).delete(' ')
      si_key = "#{days}#{start_time}"
      #get the corresponding ASI by key
      del_sched_info = source_activity_offering.requested_scheduling_information_list.by_key(si_key)
      page.get_requested_sched_info_days(row).delete(' ').should == del_sched_info.days
      page.get_requested_sched_info_start_time(row).delete(' ').should == "#{del_sched_info.start_time}#{del_sched_info.start_time_ampm}"
      page.get_requested_sched_info_end_time(row).delete(' ').should == "#{del_sched_info.end_time}#{del_sched_info.end_time_ampm}"
      page.get_requested_sched_info_facility(row).should == del_sched_info.facility_long_name
      page.get_requested_sched_info_room(row).should == del_sched_info.room
    end
    page.cancel
  end
end

Then /^I copy the course offering$/ do
  @course_offering_copy = @course_offering.copy
end

#Then /^I copy the parent course offering$/ do
#  @course_offering_copy = @activity_offering.parent_course_offering.copy
#end

Then /^I copy the colocated AO\'s parent course offering$/ do
  @course_offering_copy = @ao_list[0].parent_course_offering.copy
end

When /^I create a new course offering in a subsequent term by copying the existing course offering$/ do
  @course_offering_copy = @course_offering.create_from_existing :target_term=> Rollover::PUBLISHED_SOC_TERM
end
