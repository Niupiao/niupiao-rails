Fabricator(:ticket) do
  user
  event
  ticket_status
  price   { [50, 100, 150].sample }
end
