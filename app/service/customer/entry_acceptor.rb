class Customer::EntryAcceptor
  def initialize(customer)
    @customer = customer
  end

  def accept(program)
    ActiveRecord::Base.transaction do
      raise if Time.current < program.application_start_time
      return :closed if Time.current >= program.application_end_time
      program.lock!
      if program.entries.where(customer_id: @customer.id).exists?
        return :accepted
      elsif max = program.max_number_of_participants
        if program.entries.where(canceled: false).count < max
          program.entries.create!(customer: @customer)
          return :accepted
        else
          return :full
        end
      else
        program.entries.create!(customer: @customer)
        return :accepted
      end
    end
  end
end