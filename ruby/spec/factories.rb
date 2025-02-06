# spec/factories.rb

def build_car(id: 1, price_per_day: 2000, price_per_km: 10)
  {
    "id"             => id,
    "price_per_day"  => price_per_day,
    "price_per_km"   => price_per_km
  }
end

def build_rental(id: 1, car_id: 1, start_date: "2025-02-01", end_date: "2025-02-01", distance: 100)
  {
    "id"         => id,
    "car_id"     => car_id,
    "start_date" => start_date,
    "end_date"   => end_date,
    "distance"   => distance
  }
end
