function service(settlement)
  print((settlement.industry+settlement.agriculture+math.log10(settlement.population)/10)*(1+settlement.technology)/5)
end

settlement={}
settlement.industry=0.3
settlement.agriculture=0.5
settlement.population=1000000
settlement.technology=0.5

service(settlement)

settlement.industry=0.8
settlement.agriculture=0.8
settlement.population=100000000
settlement.technology=0.8

service(settlement)

settlement.industry=1.2
settlement.agriculture=1
settlement.population=10000000000
settlement.technology=1.5

service(settlement)