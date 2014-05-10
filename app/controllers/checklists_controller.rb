class ChecklistsController < ApplicationController

  def index
    @checklists = Checklist.order :title
  end

  def new
    @checklist = Checklist.new
    @listdata = topics_to_yaml(@checklist.topics.order "ordering")
  end
  
  def edit
    @checklist = Checklist.find(params[:id])
    @listdata = topics_to_yaml(@checklist.topics.order "ordering")
  end
    
  def show
    @checklist = Checklist.find(params[:id])
    @registration = nil

    render :layout => !request.xhr?
  end

  def create
    begin
      @checklist = Checklist.new params[:checklist]
      @checklist.save
      
      redirect_to edit_checklist_values_path(@checklist), :notice => 'Checklist was successfully created.'
    rescue Exception => msg  
      
      @checklist = Checklist.new params[:checklist]
      @checklist.errors.add(:topics,msg)

      render :action => "new"
    end
  end

  def update
    @checklist = Checklist.find params[:checklist][:id]
    @checklist.title = params[:checklist][:title]
    @checklist.grade_callback = params[:checklist][:grade_callback]
    @checklist.remarks = params[:checklist][:remarks]
    begin
      old_checks = @checklist.checks
      @checklist.topics = yaml_to_topics(params[:topics_yaml])
      @checklist.save

      ChecklistTopic.delete_all(:checklist_id => nil)
      old_checks.each do |check|
        if check.topics.empty?
          check.destroy
        end
      end
      
      redirect_to @checklist, :notice => 'Checklist was successfully created.'

    rescue Exception => msg  
      @listdata = params[:topics_yaml]
      @checklist.errors.add(:topics,msg)

      render :action => "edit"
    end
  end

  def edit_values
    @checklist = Checklist.find params[:id]
  end
  
  def new_topic
    topic = ChecklistTopic.new
    topic.title = params[:title]

    render :partial => "topic", :layout => false, :locals => { 
      :topic => topic,
      :topic_key => params[:new_key]
    }
  end
  
  def new_check
    @checklist = Checklist.new
    check = ChecklistCheck.new
    check.check = params[:title]
    link = ChecklistTopicsCheck.new
    link.check = check

    render :partial => "check", :layout => false, :locals => { 
      :link => link,
      :link_key => params[:new_key],
      :topic_key => params[:topic_key]
    }
  end
  
  def import_check
    @checklist = Checklist.find params[:checklist_id]
    check = ChecklistCheck.find params[:check_id]
    
    link = ChecklistTopicsCheck.new
    link.check = check

    render :partial => "check", :layout => false, :locals => { 
      :link => link,
      :link_key => params[:new_key],
      :topic_key => params[:topic_key]
    }
  end

  def update_values
    @checklist = Checklist.find params[:id]
    @checklist.grade_callback = params[:checklist][:grade_callback]
    @checklist.title = params[:checklist][:title]
    @checklist.save

    existingTopics = @checklist.topics.index_by { |t| t.id.to_s }
    existingLinks = @checklist.topics_checks.includes(:check).index_by &:id

    newTopics = params[:topics] || {}
    newChecks = params[:checks] || {}

    newTopics.each do |idkey, values|
      # First we fix the scale rational values
      target = BigDecimal(values["score_target"])

      if values["scale_score"].nil?
        scale = Rational(1)
        values["score_target"] = nil
      else
        unless values["scale_denominator"].to_f == 0
          scale = Rational(values["scale_numerator"], values["scale_denominator"]).round(5)
        else
          scale = Rational(0)
        end
        values["scale_numerator"] = scale.numerator
        values["scale_denominator"] = scale.denominator
      end
      
      scoretype = Scoretype.find values[:scoretype_id]
      values.delete :scoretype_id
      values.delete :scale_score

      if values["id"] == "new"
        values.delete :id
        topic = ChecklistTopic.new values
        topic.scoretype = scoretype
        topic.checklist = @checklist
        topic.save

        existingTopics[idkey] = topic
      else 
        topic = existingTopics.fetch idkey, nil
        unless topic.nil?
          values.delete :id
          topic.scoretype = scoretype
          topic.update_attributes values
        end

      end
    end

    newChecks.each do |idkey, values|
      topic = existingTopics.fetch values["topic_id"], nil
    
      if topic.nil?
        asdf
      end

      values.delete :topic_id
      
      if values["check_id"] == "new"
        check = ChecklistCheck.new values["check"]
      else 
        check = ChecklistCheck.find values["check_id"]
        check.update_attributes values["check"]
      end

      check.save

      values.delete :check_id
      values.delete :check

      if values["id"] == "new"
        values.delete :id
        link  = ChecklistTopicsCheck.new values
        link.topic = topic
        link.check = check
        link.save

        existingTopics[idkey] = topic
      else 
        link = existingLinks.fetch idkey.to_i, nil
        unless link.nil?
          values.delete :id
          link.topic = topic
          link.check = check
          link.update_attributes values
        end
      end

    end

    params[:deleted_topics_checks] ||= []

    #Integer(,10)
    unless params[:deleted_topics].nil?
      params[:deleted_topics].each do |del_id|
        topic = @checklist.topics.find del_id rescue nil
        unless topic.nil?
          params[:deleted_topics_checks].push(*topic.topics_checks.map { |tc| tc.id })
          topic.destroy
        end
      end
    end
    
    unless params[:deleted_topics_checks].nil?
      params[:deleted_topics_checks].each do |del_id|
        link = @checklist.topics_checks.find del_id rescue nil
        
        unless link.nil?
          if link.check.topics.size > 1
            link.destroy
          else
            check = link.check
            link.destroy
            check.destroy
          end
        end

      end
    end

    redirect_to @checklist, :notice => 'Checklist was successfully updated.'
  end

  def destroy
    @checklist = Checklist.find(params[:id])
    @checklist.destroy
    redirect_to checklists_path, :notice => 'Course was destroyed'
  end

  private

  def topics_to_yaml (topics)
    StyledYAML.dump format_nice(topics.map{ |topic|
      ret = topic.attributes.reject {|key,value|
        %w(ordering checklist_id scoretype_id).include? key or value.nil? 
      }
      if !topic.scoretype.nil?
        ret["scoretype"] = topic.scoretype.varname unless topic.scoretype.varname == "points"
      end
      ret["checks"] = topic.topics_checks.includes(:topic).map do |a|
        c = hide_ids_from :check, a.check.attributes.select {|key,val| 
          %w(id check varname feedback missing_feedback).include? key and !val.nil? and val != ""
        }
        c["value"] = a.value unless a.value == 0
        c["unchecked_value"] = a.unchecked_value unless a.unchecked_value == 0
        c
      end unless topic.checks.size == 0
      hide_ids_from :topic, ret 
    })
  end

  def yaml_to_topics(yaml)
    ordering = 1
    topics = YAML.load(yaml).map do |thash|
      thash = parse_ids_from :topic, thash
      if thash.has_key? "id"
        begin
          topic = ChecklistTopic.find thash["id"] 
          rescue
          topic = ChecklistTopic.new
        end
      else 
        topic = ChecklistTopic.new 
      end

      thash.each do |key,val|
        topic[key] = val unless %w(id topic scoretype checks ordering).include? key
      end

      topic.scoretype = Scoretype.find_by_varname thash.fetch("scoretype", "points")
      topic.title = thash["topic"]
      topic.ordering = ordering

      links = topic.topics_checks.includes(:check).index_by(&:checklist_check_id)
      ordering += 1

      check_ordering = 1
      topic.topics_checks = thash.fetch("checks", []).map do |chash|
        chash = parse_ids_from :check, chash
        if chash.has_key? "id" and not links[chash["id"]].nil?
          link = links[chash["id"]]
          check = link.check
        else 
          link = ChecklistTopicsCheck.new
          begin
            if chash.has_key? "id"
              check = ChecklistCheck.find chash["id"]
            else
              check = ChecklistCheck.new
            end
          rescue Exception => msg  
            check = ChecklistCheck.new
          end
          link.check = check
        end

        chash["feedback"] ||= ""
        chash["missing_feedback"] ||= ""
        chash.each do |key,val|
          check[key] = val unless %w(id ordering value unchecked_value).include? key
        end

        link.ordering = check_ordering
        link.value = chash["value"] || 0
        link.unchecked_value = chash["unchecked_value"] || 0
        check_ordering += 1

        if chash.has_key? "id"
          check.save 
          link.save
        end
        
        link
      end

      topic.save if thash.has_key? "id"

      topic
    end
    topics
  end

  def hide_ids_from(key,hash)
    return hash unless hash.has_key? "id"

    key = key.to_s
    id = hash["id"]
    keyval = hash[key]

    hash.delete "id"
    hash.delete key

    ret = {key+" "+id.to_s => keyval}
    hash.each { |k,v| ret[k] = v }
    ret
  end

  def parse_ids_from(idkey,hash)
    idkey = idkey.to_s
    ret = {}
    regexp = "^"+idkey+" ([0-9]+)$"

    hash.each do |key,val|
      if key.match regexp
        ret[idkey] = val
        ret["id"] = $1.to_i
      else
        ret[key] = val
      end
    end

    ret

  end

  def format_nice (coll)
    if coll.is_a? Hash
      coll.each do |key, value|
        coll[key] = format_nice(value)
      end
    elsif coll.is_a? Array
      coll = coll.map do |value|
        format_nice(value)
      end
    elsif coll.is_a? String and !coll.index("\n").nil?
      coll = StyledYAML.literal(coll)
    end
    coll
  end

end
