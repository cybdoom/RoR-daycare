require 'csv'
class Daycare < ActiveRecord::Base
  has_one  :manager, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_many :parents, dependent: :destroy
  has_many :children, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :departments, dependent: :destroy
  # has_many :todos, dependent: :destroy
  has_many :create_permissions, dependent: :destroy
  has_many :edit_permissions, dependent: :destroy
  has_many :view_permissions, dependent: :destroy
  has_many :report_permissions, dependent: :destroy
  has_many :daycare_todos, dependent: :destroy
  has_many :todos, through: :daycare_todos
  belongs_to :customer_type

  validates :name, :country, :language, :address_line1, :customer_type_id, presence: true

  accepts_nested_attributes_for :manager, :departments, allow_destroy: true, reject_if: :all_blank
  
  def self.import(file, customer_type_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      unless Manager.exists?(email: row['Daycare Manager Email'])
        @daycare = Daycare.new
        @daycare.country = row['Country']
        @daycare.language = row['Language']
        @daycare.name = row['Customer Name']
        @daycare.address_line1 = row['Address']
        @daycare.post_code = row['Postcode'].to_s
        @daycare.telephone = row['Telephone'].to_s
        @daycare.customer_type_id = customer_type_id
        CSV.parse_line(row['Department Names']).each do |name|
          @daycare.departments.build(department_name: name)
        end
        manager = @daycare.build_manager
        manager.name = row['Daycare Manager Name']
        manager.email = row['Daycare Manager Email']
        manager.password = Devise.friendly_token.first(8)

        CSV.parse_line(row['Daycare Worker Names']).each_with_index do |name, index|
          @worker = @daycare.workers.build(name: name)
          email = CSV.parse_line(row['Daycare Worker Emails'])[index]
          @worker.email = email if email.present?
          @worker.password = Devise.friendly_token.first(8)
        end

        CSV.parse_line(row['Daycare Children Names']).each do |name|
          @child = @daycare.children.build(name: name)
        end

        CSV.parse_line(row['Daycare Parent Names']).each_with_index do |name, index|
          @worker = @daycare.parents.build(name: name)
          email = CSV.parse_line(row['Daycare Parent Emails'])[index]
          @worker.email = email if email.present?
          @worker.password = Devise.friendly_token.first(8)
        end
      end
    end
    @daycare
  end
  
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, packed: nil, file_warning: :ignore)
    when ".xls" then Roo::Excel.new(file.path, packed: nil, file_warning: :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
