module Xeroizer
  module Record
    module Payroll

      class EmployeeModel < PayrollBaseModel

        set_permissions :read, :write, :update
        def create_method
          :http_post
        end
      end

      class Employee < PayrollBase

        set_primary_key :employee_id

        guid          :employee_id
        string        :status
        # string        :title
        string        :first_name
        string        :middle_names
        string        :last_name
        date          :start_date
        string        :email
        date          :date_of_birth # YYYY-MM-DD
        string        :gender
        string        :phone
        string        :mobile
        string        :twitter_user_name
        boolean       :is_authorised_to_approve_leave
        boolean       :is_authorised_to_approve_timesheets
        string        :occupation
        string        :classification
        guid          :ordinary_earnings_rate_id
        guid          :payroll_calendar_id
        string        :employee_group_name
        date          :termination_date
        datetime_utc  :updated_date_utc, :api_name => 'UpdatedDateUTC'

        has_many      :bank_accounts
        has_one       :home_address, :internal_name_singular => "home_address", :model_name => "HomeAddress"
        has_one       :tax_declaration, :internal_name_singular => "tax_declaration", :model_name => "TaxDeclaration"
        has_one       :pay_template, :internal_name_singular => "pay_template", :model_name => "PayTemplate"
        has_many      :super_memberships

        validates_presence_of :employee_id, :unless => :new_record?
        validates_presence_of :first_name, :last_name
        validates_length_of :first_name, :last_name, length: { maximum: 50 }, :allow_blanks => true
        validates_length_of :title, length: { maximum: 10 }, :allow_blanks => true
        validates_length_of :middle_names, :phone, :mobile, :twitter_user_name, :occupation, length: { maximum: 50 }, :allow_blanks => true
        validates_length_of :email, :classification, length: { maximum: 100 }, :allow_blanks => true
        validates_inclusion_of :gender, :in => %w{M F}, :message => "%{value} is not a valid gender value", :allow_blanks => true

        # US Payroll fields
        string        :job_title
        string        :employee_number
        string        :social_security_number
        guid          :pay_schedule_id
        string        :employment_basis
        guid          :holiday_group_id
        boolean       :is_authorised_to_approve_time_off

        has_many      :salary_and_wages
        has_many      :work_locations
        has_one       :payment_method, :model_name => "PaymentMethod"
        has_one       :mailing_address, :internal_name_singular => "mailing_address", :model_name => "MailingAddress"

        validates_presence_of :first_name, :last_name, :unless => :new_record?
        validates_presence_of :date_of_birth
        validates_presence_of :pay_schedule_id, :if => Proc.new { | record | !record.salary_and_wages.blank? }
      end
    end
  end
end
