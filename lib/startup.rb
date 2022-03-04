require "employee"

class Startup
    attr_reader :name, :funding, :salaries, :employees

    def initialize(name, funding, salaries)
        @name = name
        @funding = funding
        @salaries = salaries
        @employees = []
    end

    def valid_title?(title)
        salaries.has_key?(title)
    end

    def >(startup)
        self.funding > startup.funding
    end

    def hire(name, employee_title)
        if self.valid_title?(employee_title)
            @employees << Employee.new(name, employee_title)
        else
            raise "title is not valid"
        end
    end

    def size
        @employees.length
    end

    def pay_employee(employee)
        money_owed = @salaries[employee.title]
        if @funding >= money_owed
            employee.pay(money_owed)
            @funding -= money_owed
        else
            raise "Not enough funding"
        end
    end

    def payday
        @employees.each { |employee| self.pay_employee(employee) }
    end

    def average_salary
        employee_salaries = []
        @employees.each { |employee| employee_salaries << @salaries[employee.title] }
        employee_salaries.sum / employees.length
    end

    def close
        @employees = []
        @funding = 0
    end

    def acquire(other_startup)
        @funding += other_startup.funding

        other_startup.salaries.each do |title, salary|
            if !salaries.has_key?(title)
                salaries[title] = salary
            end
        end

        @employees += other_startup.employees

        other_startup.close
    end
end
