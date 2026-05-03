#!/usr/bin/env ruby

require_relative 'trimp_calculator'

ENTRENO = Struct.new(:description, :duration, :avg_hr)
RESULTADO = Struct.new(:trimp, :btrip, :etrip, :zone_info)

gender = :male
resting_hr = 55
max_hr = 184

entrenos = [
  ENTRENO.new('Marismas Blancas - Sprint', 48, 148),
  ENTRENO.new('4x4', 64, 135),
  ENTRENO.new('Entrenamiento en cinta', 45, 129),
  ENTRENO.new('Km Vertical Matienzo de bajada', 23, 150),
  ENTRENO.new('Km Vertical Matienzo', 42, 166),
  ENTRENO.new('Cardio', 60, 98)
]

resultados = []

entrenos.each_with_index do |entreno, index|
  calculator = TRIMPCalculator.new(entreno.duration, entreno.avg_hr, max_hr, resting_hr, gender)
  trimp = calculator.calculate
  btrimp = calculator.calculate_btrimp
  etrip = calculator.calculate_etrimp
  zone_info = calculator.get_zone_info

  resultados << RESULTADO.new(trimp, btrimp, etrip, zone_info)
end

totales = {}
puts "\n=== Summary ==="
resultados.each do |resultado|
  totales[:trimp] ||= 0
  totales[:trimp] += resultado.trimp

  totales[:btrimp] ||= 0
  totales[:btrimp] += resultado.btrip

  totales[:etrimp] ||= 0
  totales[:etrimp] += resultado.etrip
  totales[:zone_info] ||= []
end

totales[:trimp] = totales[:trimp].round(2)
totales[:btrimp] = totales[:btrimp].round(2)
totales[:etrimp] = totales[:etrimp].round(2)

classification = TRIMPCalculator.classify_trimp(totales[:trimp])
btrimp_classification = TRIMPCalculator.classify_btrimp(totales[:btrimp])
etrimp_classification = TRIMPCalculator.classify_etrimp(totales[:etrimp])

# Classify the weekly TRIMP
puts "  TRIMP Score: #{totales[:trimp]} - #{classification[:interpretation]}"
puts "  bTRIMP Score: #{totales[:btrimp]} - #{btrimp_classification[:interpretation]}"
puts "  eTRIMP Score: #{totales[:etrimp]} - #{etrimp_classification[:interpretation]}"



