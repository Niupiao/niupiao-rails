Fabricator(:ticket) do
  user
  event
  price   { [50, 100, 150].sample }
  status  { [Ticket::STATUS_VIP, Ticket::STATUS_GENERAL].sample }
end
