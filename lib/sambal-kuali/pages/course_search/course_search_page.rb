class CourseSearch < BasePage

  page_url "#{$test_site}myplan/course?methodToCall=start&viewId=CourseSearch-FormView"


  wrapper_elements
  frame_element

  element(:search_for_course) { |b| b.frm.text_field(id: "text_searchQuery_control") }
  element(:search_term) { |b| b.frm.select(name:"searchTerm") }
  action(:search) { |b| b.frm.button(id:"searchForCourses").click; b.loading.wait_while_present }
  action(:clear) { |b| b.frm.button(id:"clearSearch").click }
  element(:results_table){ |b| b.frm.div(id: /course_search_results/).table }

  COURSE_CODE = 0


 def results_list
   list = []
   results_table.rows.each do |row|
     list << row[COURSE_CODE].text
   end
   list.delete_if { |item| item == "Code" }
   list.delete_if {|item| item == "" }
   STDERR.puts "array is #{list.inspect}"
   list
 end

  def results_list_courses (verify)
  # on CourseSearch do |page|
      final= Array.new
       puts results_list
      final<<results_list.map! {|x| x.slice(0,4) }
      final.each {|e| puts e
      if e.include? (verify)
        puts true
      else
        puts false
      end

      }
    end


  def modified_list
   results_list

 end
end