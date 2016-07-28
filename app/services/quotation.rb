class Quotation
  def self.quotes
    []
  end

  def self.any
    Faker::Lorem.sentence
  end
end