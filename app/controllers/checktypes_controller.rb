class ChecktypesController < ApplicationController
  def create
    @checktype = Checktype.new(params[:checktype])
    if @checktype.save
      redirect_to checks_path, :notice => 'Category was successfully created.'
    else
      redirect_to checks_path, :notice => 'Could not create category'
    end
  end
  def update
    #TODO: check if this works
    @checktype = Checktype.find(params[:id])
    @checktype.update_attributes!(params[:checktype])
    redirect_to checks_path, :notice => 'Category renamed'
  end
  def destroy
    @checktype = Checktype.find(params[:id])
    @checktype.destroy
    redirect_to checks_path, :notice => 'Category was deleted'
  end
end
