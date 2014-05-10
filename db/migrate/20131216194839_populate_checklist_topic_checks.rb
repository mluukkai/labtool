class PopulateChecklistTopicChecks < ActiveRecord::Migration
  def up
    execute 'update checklist_checks set value = 0 where value is null;'
    execute 'update checklist_checks set unchecked_value = 0 where unchecked_value is null;'
    
    change_column :checklist_checks, :value, :decimal, :default => 0, :null => false
    change_column :checklist_checks, :unchecked_value, :decimal, :default => 0, :null => false

    execute 'insert into checklist_topics_checks(checklist_topic_id,checklist_check_id,ordering,weight_factor) 
    select c2.checklist_topic_id, c1.id, c2.ordering, 
      case c1.value 
        when 0 then 
          case c1.unchecked_value 
            when 0 then 1
            else c2.unchecked_value/c1.unchecked_value 
          end 
        else 
          c2.value/c1.value 
      end 
    from (
      select c.* from checklist_checks c join
        (select min(id) id, "check", "feedback", "missing_feedback" from checklist_checks group by "check", feedback, missing_feedback) minc 
        on c.id = minc.id
      ) c1 
    join checklist_checks c2 on c1."check" = c2."check" 
         and (c1.feedback = c2.feedback or (c1.feedback is null and c2.feedback is null))
         and (c1.missing_feedback = c2.missing_feedback or (c1.missing_feedback is null and c2.missing_feedback is null))'
  end

  def down
  end
end
