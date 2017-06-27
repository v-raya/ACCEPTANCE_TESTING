# frozen_string_literal: true

RSpec::Matchers.define :be_before do |expected|
  match do |actual|
    expect(page.body.index(actual)).to be < page.body.index(expected)
  end
end

RSpec::Matchers.define :be_after do |expected|
  match do |actual|
    expect(page.body.index(actual)).to be > page.body.index(expected)
  end
end
