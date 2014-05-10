
class PassedChecksController < ApplicationController
    
  def show
    @checklist = Checklist.find(params[:id])
    @registration = Registration.find(params[:registration_id])
    render :template => "checklists/show", :layout => !request.xhr?
  end
    
  def update
    @checklist = Checklist.find(params[:id])
    if params[:registration].nil?
      return render :template => "checklists/show", :layout => !request.xhr?
    end
    @registration = Registration.find(params[:registration])

    checks = @checklist.passed_checks.where(:registration_id => @registration.id)
    check_map = {}
    checks.each do |a|
      a.selected = false
      check_map[a.checklist_check_id] = a
    end

    params.fetch(:checks,{}).each do |check_id, selected|
      a = check_map.fetch check_id.to_i, PassedCheck.new
      a.registration = @registration
      a.checklist_check_id = check_id
      a.selected = true;

      check_map[check_id] = a
    end

    check_map.each do |k,a|
      a.save
    end

    render :template => "checklists/show", :layout => !request.xhr?
  end
end
