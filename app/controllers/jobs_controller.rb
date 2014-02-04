class JobsController < ApplicationController

  def index
    @active_jobs = Job.active.with_org_name_url
    @hiring_orgs = Organization.hiring
  end
end
