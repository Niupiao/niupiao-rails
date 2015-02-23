Fabricator(:ticket) do
  user
  event
  price   { [50, 100, 150].sample }
  status  { %w(vip general).sample }
end
