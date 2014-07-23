
Then(/^I should see a gutter for bookmarks$/) do
 on CoursePlannerPage do |page|
   page.bookmark_gutter.exists?.should==true
 end
end



When(/^I navigate to the Planner page$/) do
  navigate_to_course_planner_home
 end


And(/^I click on View more details link$/) do

  on CoursePlannerPage do |page|
 page.view_more_details.click
  end
end


Then(/^I should be able to see a page that displays the bookmarks and display the CDP overview section information$/) do
on BookmarkPage do |page|
  page.browser_secondary_nav.exists?.should==true
end
end


When(/^I bookmark a course$/) do

  @course_search_result = make CourseSearchResults,:course_code => "ENGL201"
  @course_search_result.course_search
  #Search for a course
  @course_search_result.navigate_course_detail_page

  on CourseDetailPage do |page|
    sleep 2
    puts page.removebookmark.exists?
    if page.removebookmark.exists?.should==true then
      puts page.removebookmark.exists?
      else
      page.add_bookmark
    end
  end




end
Then(/^I should be able to view a link to bookmark page in the secondary navigation$/) do
  on BookmarkPage do |page|
    page.browser_secondary_nav.exists?.should==true
  end
end