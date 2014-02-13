class JobsController < ApplicationController

  def index
    @active_jobs = Job.active.page(params[:page]).per(10)
    @hiring_orgs = Organization.hiring
  end
end
