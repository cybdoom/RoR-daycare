class Daycare < ActiveRecord::Base
  has_one  :manager, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_many :parents, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :departments, dependent: :destroy
  has_many :todos, dependent: :destroy

  accepts_nested_attributes_for :manager, :departments, allow_destroy: true, reject_if: :all_blank
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if !Daycare.exists?(:username => row["username"])
        customer = Daycare.new
        #customer.attributes = row.to_hash.slice(*row.to_hash.keys)
        customer.customer_name = row["customer name"]
        customer.username = row["username"]
        customer.password = row["password"]
        customer.email = row["email"]
        customer.country = row["country"]
        
        #Daycare customer
        if file.original_filename == "Daycare-Customers.xlsx"
          daycare_type = CustomerType.find_by(:type_name => "Daycare Customer")
          customer.customer_type_id = daycare_type.id
          customer.daycare_user_type = row["daycare user type"]
          daycare_department = DaycareDepartment.find_by(:department_name => row["daycare department"])
          if daycare_department.nil?
            daycare_department = DaycareDepartment.create(:department_name => row["daycare department"])
          end
          customer.daycare_department_ids = daycare_department.id
          
          daycare_type = nil
          daycare_department = nil
        
        #Daycare partner
        elsif file.original_filename == "Daycare-Partners.xlsx"
          partner_type = CustomerType.find_by(:type_name => row["customer type"])
          if partner_type.nil?
            partner_type = CustomerType.create(:type_name => row["customer type"])
          end
          customer.customer_type_id = partner_type.id
          
          partner_type = nil
        end
        
        customer.save!
      end
    end
    
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
