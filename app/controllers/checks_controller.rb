class ChecksController < ApplicationController

  def index
    @uncategorised = ChecklistCheck.order(:ordering).find_all_by_type_id nil
    @types = Checktype.includes(:checks, :topics_checks).order :name
  end

  def new
  end
  def edit
  end
  def show
  end
  def create
  end
  def update
  end

  def reorder
    type = nil
    type =  Checktype.find(params[:id]) unless params[:id] == "0"
    checks = ChecklistCheck.find_all_by_id(params[:checks]).index_by(&:id)
    ordering = 1;

    params[:checks].each do |id|
      check = checks[id.to_i]
      unless check.nil?
        check.checktype = type
        check.ordering = ordering;
        check.save!
        ordering += 1;
      end
    end

    render :json => { :status => :ok }
  end

  def destroy
    #@checklist = Checklist.find(params[:id])
    #@checklist.destroy
    #redirect_to checklists_path, :notice => 'Course was destroyed'
  end

end
