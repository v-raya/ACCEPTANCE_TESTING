# frozen_string_literal: true

# date time helper
def past_date(date: nil, **args)
  if date.blank?
    date = Faker::Time.between(DateTime.now - args.fetch(:a, 10).to_i,
                               DateTime.now - args.fetch(:b, 5).to_i)
  end
  date.strftime('%m/%d/%Y')
end

def past_date_time(date_time: nil, **args)
  if date_time.blank?
    date_time = Faker::Time.between(DateTime.now - args.fetch(:a, 10).to_i,
                                    DateTime.now - args.fetch(:b, 5).to_i)
  end
  date_time.strftime('%m/%d/%Y %l:%M %p')
end

def future_date(date: Faker::Date.forward(rand(1..5)))
  date.strftime('%m/%d/%Y')
end

def future_date_time(date_time: Faker::Time.forward(rand(1..5)))
  date_time.strftime('%m/%d/%Y %l:%M %p')
end

def date_of_birth(age: 1)
  (Date.today - (365 * age)).strftime('%m/%d/%Y')
end
