When /^I move an activity offering to the cluster$/ do
  @course_offering.activity_offering_cluster_list[0].move_ao_to_another_cluster("A",@course_offering.activity_offering_cluster_list[1])
end

Given /^I have created an additional activity offering cluster for a catalog course offering$/ do
  @course_offering = make CourseOffering, :term=>Rollover::MAIN_TEST_TERM_TARGET, :course=>"CHEM277"
  @course_offering.initialize_with_actual_values
  ao_cluster = make ActivityOfferingClusterObject
  @course_offering.add_ao_cluster(ao_cluster)
end

When /^I create a(?:n| new) activity offering cluster$/ do
  @ao_cluster = make ActivityOfferingClusterObject
  @course_offering.add_ao_cluster(@ao_cluster)
end

When /^I create a Discussion Lecture activity offering cluster$/ do
  @ao_cluster = make ActivityOfferingClusterObject, :format => "Discussion/Lecture"
  @course_offering.add_ao_cluster(@ao_cluster)
end

Then /^the new activity offering cluster is present$/ do
  found_it = false
  @course_offering.activity_offering_cluster_list.each do |cluster|
    if cluster.private_name == @ao_cluster.private_name
      found_it = true
    end
  end
  found_it.should == true
end

Given /^there are default registration groups for a course offering$/ do
  @course_offering = make CourseOffering, :course=>"CHEM277", :term=>Rollover::OPEN_SOC_TERM
  @course_offering.initialize_with_actual_values
end

Given /^I have created an additional activity offering cluster for a course offering$/ do
  @course_offering = (make CourseOffering, :course=>"CHEM277", :term=>Rollover::OPEN_SOC_TERM).copy
  #@course_offering = make CourseOffering, :course=>"CHEM277A", :term=>Rollover::OPEN_SOC_TERM
  @course_offering.initialize_with_actual_values
  existing_cluster = @course_offering.activity_offering_cluster_list[0]
  new_ao = @course_offering.copy_ao :ao_code =>  existing_cluster.ao_list[0].code
  new_cluster = make ActivityOfferingClusterObject
  @course_offering.add_ao_cluster(new_cluster)
  existing_cluster.move_ao_to_another_cluster(new_ao.code, new_cluster)

end

Given /^there are default registration groups for a catalog course offering$/ do
  @course_offering = make CourseOffering, :term=>Rollover::SOC_STATES_SOURCE_TERM, :course=>"ENGL245"
  @course_offering.initialize_with_actual_values
end


When /^I try to create a second activity offering cluster with the same private name$/ do
  @ao_cluster2 = create ActivityOfferingClusterObject, :private_name=>@ao_cluster.private_name
end

When /^I try to create a second activity offering cluster with a different private name$/ do
  @ao_cluster2 = create ActivityOfferingClusterObject
end

Then /^a cluster error message appears stating "(.*?)"$/ do |expected_errMsg|
  on ManageCourseOfferings do |page|
    page.get_cluster_error_msgs.should match /#{expected_errMsg}/
  end
end

Then /^for the original cluster a warning message appears stating "(.*?)"$/ do |errMsg|
  cluster_private_name = @course_offering.activity_offering_cluster_list[0].private_name
  on ManageCourseOfferings do |page|
    page.get_cluster_warning_msgs(cluster_private_name).should match /#{cluster_private_name}.+#{errMsg}/
  end
end

Then /^I try to rename the second activity offering cluster to the same private name as the first$/ do
    @ao_cluster2.rename :private_name=> @ao_cluster.private_name
end

Then /^I remove the newly created cluster$/ do
  @ao_cluster.delete
end


Then /^the edit Activity Offering page is displayed$/ do
  on ActivityOfferingMaintenance do |page|
    page.mainpage_section.present?.should be_true
  end
end

When /^I return from the edit Activity Offering page$/ do
  on ActivityOfferingMaintenance do |page|
    page.cancel
  end
end

And /^I submit the Activity Offering changes$/ do
  on ActivityOfferingMaintenance do |page|
    page.submit
  end
end

Then /^the Manage Course Offerings page is displayed$/ do
  on ManageCourseOfferings do |page|
    page.term.present?.should be_true
  end
end

Given /^I manage registration groups for a new course offering with multiple AO types and only one lecture activity$/ do
  @course_offering = (make CourseOffering, :course=>"CHEM237", :term=>"201301").copy
  @course_offering.initialize_with_actual_values
end

Given /^I manage registration groups for a new course offering$/ do
  @course_offering = (make CourseOffering, :course=>"CHEM135", :term=>"201301").copy
  @course_offering.initialize_with_actual_values
end

Then /^the Activity Offerings are present in the activity offering cluster$/ do
  @course_offering.activity_offering_cluster_list[0].ao_list.count.should > 0
end

When /^the corresponding number of registration groups for each cluster is correct$/ do
  on ManageCourseOfferings do |page|
    @course_offering.activity_offering_cluster_list.each do |cluster|
      if page.view_reg_groups_table(cluster.private_name).present? == false
        page.view_cluster_reg_groups(cluster.private_name)
      end
      page.get_cluster_reg_groups_list(cluster.private_name).length.should == cluster.ao_list.count{|x| x.activity_type == "Discussion"} * cluster.ao_list.count{|x| x.activity_type == "Lecture"}
    end
  end
end

When /^Move one lab and one lecture activity offering to the second cluster$/ do
    @course_offering.activity_offering_cluster_list[0].move_ao_to_another_cluster("A", @course_offering.activity_offering_cluster_list[1])
    @course_offering.activity_offering_cluster_list[0].move_ao_to_another_cluster("J", @course_offering.activity_offering_cluster_list[1])
end

Then /^the cluster and pertaining AO's are deleted$/ do
  @course_offering.activity_offering_cluster_list.each do |cluster|
    cluster.private_name.should_not == @deleted_aoc
  end
end

When /^I copy an Activity Offering$/ do
   @course_offering.copy_ao :ao_code=>"A"
end

When /^I add an Activity Offering$/ do
  @course_offering.create_ao :ao_obj => (make ActivityOfferingObject, :format => "Lecture/Discussion")
end

When /^I update an Activity Offering to have less seats$/ do
  actvity_offering = make ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster, :code => 'A'
  actvity_offering.edit :max_enrollment => 200
end

Then /^a warning message is displayed stating "([^"]*)"$/ do |msg|
  on ManageCourseOfferings do |page|
    page.get_cluster_warning_msgs.include?(msg)
  end
end

When /^I update an Activity Offering to create a time conflict$/ do
  actvity_offering = make ActivityOfferingObject, :parent_cluster => @course_offering.default_cluster, :code => 'B'
  actvity_offering.edit :rsi_obj => (make SchedulingInformationObject, :days=>"M")
 end

When /^I edit the Activity Offering$/ do
  @course_offering.find_ao_obj_by_code('A').edit :defer_save => true
end

When /^I move a lecture activity offering to the new cluster$/ do
  @course_offering.activity_offering_cluster_list[0].move_ao_to_another_cluster("A", @course_offering.activity_offering_cluster_list[1])
end

When /^I delete an Activity Offering$/ do
   @course_offering.get_ao_obj_by_code("B").delete
end