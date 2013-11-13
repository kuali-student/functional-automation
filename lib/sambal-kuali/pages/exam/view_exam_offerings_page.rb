class ViewExamOfferings < BasePage

  wrapper_elements
  frame_element
  expected_element :exam_offerings_page_section

  element(:exam_offerings_page_section) { |b| b.frm.div(id: "viewExamOfferingsPage")}

  element(:canceled_table_header_text) { |b| b.exam_offerings_page_section.span( class: "uif-headerText-span").text}
  element(:canceled_eo_table) { |b| b.exam_offerings_page_section.div( class: "dataTables_wrapper").table}

  ############## Course Offering page for View Exam Offerings ####################
  element(:eo_by_co_table_section) { |b| b.frm.div(id: "KS-CourseOfferingManagement-ExamOfferingByCOTableSection")}
  element(:co_table_header) { |b| b.eo_by_co_table_section.span(class: "uif-headerText-span")}
  value(:co_table_header_text) { |b| b.co_table_header.text}

  CO_STATUS = 0
  CO_DAYS = 1
  CO_ST_TIME = 2
  CO_END_TIME = 3
  CO_BLDG = 4
  CO_ROOM = 5

  def eo_by_co_results_table
    return eo_by_co_table_section.table unless !eo_by_co_table_section.table.exists?
  end

  def eo_by_co_target_row
    row = eo_by_co_results_table.rows[1]
    return row unless row.nil?
  end

  def eo_by_co_status
    eo_by_co_target_row.cells[CO_STATUS].text
  end

  def eo_by_co_days
    eo_by_co_target_row.cells[CO_DAYS].text
  end

  def eo_by_co_st_time
    eo_by_co_target_row.cells[CO_ST_TIME].text
  end

  def eo_by_co_end_time
    eo_by_co_target_row.cells[CO_END_TIME].text
  end

  def eo_by_co_bldg
    eo_by_co_target_row.cells[CO_BLDG].text
  end

  def eo_by_co_room
    eo_by_co_target_row.cells[CO_ROOM].text
  end

  def count_no_of_eos_by_co
    row_count = 0
    eo_by_co_results_table.rows.each do |row|
      if row.text !~ /^Status.*$/ and row.text != ""
        row_count += 1
      end
    end
    return "#{row_count}"
  end

  ############## Activity Offering page for View Exam Offerings ####################
  element(:eo_by_ao_table_section) { |b| b.frm.div(id: "KS-CourseOfferingManagement-ExamOfferingByAOClustersSection")}
  element(:ao_table_header) { |b| b.eo_by_ao_table_section.span(class: "uif-headerText-span")}
  value(:ao_table_header_text) { |b| b.ao_table_header.text}
  element(:cluster_list_div)  { |b| b.frm.eo_by_ao_table_section.div(class: "uif-stackedCollectionLayout") }

  AO_STATUS = 0
  AO_CODE = 1
  AO_TYPE = 2
  AO_DAYS = 3
  AO_ST_TIME = 4
  AO_END_TIME = 5
  AO_BLDG = 6
  AO_ROOM = 7

  def eo_by_ao_results_table(cluster_private_name = :default_cluster)
    if cluster_private_name == :default_cluster then
      return cluster_div_list[0].table unless !cluster_div_list[0].table.exists?
    else
      cluster = target_cluster(cluster_private_name)
      if cluster != nil
        return cluster.table unless !cluster.table.exists?
      else
        return nil
      end
    end
    raise "error in activity_offering_results_table - no AOs for #{cluster_private_name}"
  end

  def view_eo_by_ao(code, cluster_private_name = :default_cluster)
    view_eo_by_ao_link(code, cluster_private_name).click
    loading.wait_while_present
  end

  def view_eo_by_ao_link(code, cluster_private_name = :default_cluster)
    eo_by_ao_results_table(cluster_private_name).link(text: code)
  end

  def eo_by_ao_target_row(code, cluster_private_name = :default_cluster)
    row = eo_by_ao_results_table(cluster_private_name).row(text: /\b#{Regexp.escape(code)}\b/)
    return row unless row.nil?
    raise "error in target_row: #{code} not found"
  end

  def eo_by_ao_status(code, cluster_private_name = :default_cluster)
    eo_by_ao_target_row(code, cluster_private_name).cells[AO_STATUS].text
  end

  def eo_by_ao_type(code, cluster_private_name = :default_cluster)
    eo_by_ao_target_row(code, cluster_private_name).cells[AO_TYPE].text
  end

  def eo_by_ao_days(code, cluster_private_name = :default_cluster)
    eo_by_ao_target_row(code, cluster_private_name).cells[AO_DAYS].text
  end

  def eo_by_ao_st_time(code, cluster_private_name = :default_cluster)
    eo_by_ao_target_row(code, cluster_private_name).cells[AO_ST_TIME].text
  end

  def eo_by_ao_end_time(code, cluster_private_name = :default_cluster)
    eo_by_ao_target_row(code, cluster_private_name).cells[AO_END_TIME].text
  end

  def eo_by_ao_bldg(code, cluster_private_name = :default_cluster)
    eo_by_ao_target_row(code, cluster_private_name).cells[AO_BLDG].text
  end

  def eo_by_ao_room(code, cluster_private_name = :default_cluster)
    eo_by_ao_target_row(code, cluster_private_name).cells[AO_ROOM].text
  end

  #def count_no_of_eos_by_ao
  #  row_count = 0
  #  eo_by_ao_results_table.rows.each do |row|
  #    if row.cells[AO_CODE].text =~ /^[A-Z]$/
  #      row_count += 1
  #    end
  #  end
  #  return "#{row_count}"
  #end

  def return_array_of_ao_codes(cluster_private_name = :default_cluster)
    array = []
    results = eo_by_ao_results_table(cluster_private_name)
    if results != nil
      results.rows.each do |row|
        if row.cells[AO_CODE].text =~ /^[A-Z]$/
          array << row.cells[AO_CODE].text
        end
      end
    end
    if !array.empty?
      return array
    else
      return nil
    end
  end

  #########Clusters #############################
  def cluster_div_list
    div_list = []
    if cluster_list_div.exists?
      div_list = cluster_list_div.divs(class: "uif-collectionItem uif-boxCollectionItem")
    end
    div_list
  end

  def target_cluster(private_name)
    div_list = cluster_div_list
    return div_list[0] if private_name == :default_cluster
    cluster_div_list.each do |div_element|
      if cluster_div_private_name(div_element) == private_name then
        return div_element
      end
    end
    return nil
  end

  def cluster_div_private_name(cluster_div_element)
    tmp_text = cluster_div_element.fieldset.label.text
    end_of_private_name = -1
    end_of_private_name = tmp_text.index('(')-2 unless tmp_text.index('(') == nil
    tmp_text[9..end_of_private_name]
  end
end