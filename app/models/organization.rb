class Organization < ActiveRecord::Base
  before_save :delete_logo

  has_many :jobs
  has_many :projects
  has_many :organization_metrics
  has_many :sponsorships

  attr_accessible :name, :url, :github_org, :description, :is_tax_exempt, :contact_name, :contact_role, :contact_email, :annual_budget_usd, :total_staff_size, :tech_staff_size, :notes, :image_url, :twitter, :logo, :logo_delete
  attr_accessible :organization_metrics_attributes, :projects_attributes

  attr_accessor :is_public_submission

  validates_presence_of :name
  validates_presence_of :github_org, :if => :is_public_submission

  #Paperclip
  has_attached_file :logo, :styles => { :thumb => "100x100>", :medium => "250x250>" },
                    :url  => "/system/images/logos/:class/:style/:id_:basename.:extension"
  validates_attachment_size :logo, :less_than => 5.megabytes
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  accepts_nested_attributes_for :organization_metrics, :projects

  include FriendlyId
  friendly_id :name, use: :slugged


  default_scope { order("name") }
  scope :approved, joins(:projects).where(:projects=>{:is_approved=>true}).uniq
  scope :featured, approved.joins(:projects).where(:projects=>{:is_active=>true}).uniq
  scope :hiring, joins(:jobs).uniq
  scope :sponsors, Organization.joins(:sponsorships).order("sponsorships.tier, organizations.name")

  def display_url
    display_url = self.url.gsub(/^https?:\/\//,"")
  end

  def github_url
    github_url = ("http://github.com/" + self.github_org) unless self.github_org.blank?
  end

  def twitter_url
    twitter_url = ("http://twitter.com/" + self.twitter) unless self.twitter.blank?
  end

  def logo_delete
    @logo_delete || '0'
  end

  def logo_delete=(str)
      @logo_delete = str
  end

  private
    def delete_logo
      self.logo.clear if self.logo_delete == '1'
    end
end
