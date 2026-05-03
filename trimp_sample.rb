#!/usr/bin/env ruby

require_relative 'trimp_calculator'

ENTRENO = Struct.new(:description, :duration, :avg_hr)
RESULTADO = Struct.new(:trimp, :btrimp, :etrimp, :zone_info)

gender = :male
resting_hr = 60
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
  etrimp = calculator.calculate_etrimp

  resultados << RESULTADO.new(trimp, btrimp, etrimp)
end

totales = {}
  
puts
puts "\n=== Individual TRIMP Summary ==="
resultados.each do |resultado|
  totales[:trimp] ||= 0
  totales[:trimp] += resultado.trimp

  totales[:btrimp] ||= 0
  totales[:btrimp] += resultado.btrimp

  totales[:etrimp] ||= 0
  totales[:etrimp] += resultado.etrimp

  puts "  TRIMP: #{resultado.trimp.round(2)}, bTRIMP: #{resultado.btrimp.round(2)}, eTRIMP: #{resultado.etrimp.round(2)}"
end

totales[:trimp] = totales[:trimp].round(2)
totales[:btrimp] = totales[:btrimp].round(2)
totales[:etrimp] = totales[:etrimp].round(2)

classification = TRIMPCalculator.classify_trimp(totales[:trimp])
btrimp_classification = TRIMPCalculator.classify_btrimp(totales[:btrimp])
etrimp_classification = TRIMPCalculator.classify_etrimp(totales[:etrimp])

training_phase = TRIMPCalculator.classify_training_phase(totales[:trimp])
btrimp_phase = TRIMPCalculator.classify_training_phase_btrimp(totales[:btrimp])
etrimp_phase = TRIMPCalculator.classify_training_phase_etrimp(totales[:etrimp])

# Classify the weekly TRIMP
puts
puts "\n=== Weekly TRIMP Summary ==="
puts "  TRIMP Score: #{totales[:trimp]} - #{classification[:interpretation]} - Phase: #{training_phase[:description]}"
puts "  bTRIMP Score: #{totales[:btrimp]} - #{btrimp_classification[:interpretation]} - Phase: #{btrimp_phase[:description]}"
puts "  eTRIMP Score: #{totales[:etrimp]} - #{etrimp_classification[:interpretation]} - Phase: #{etrimp_phase[:description]}"