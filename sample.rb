#!/usr/bin/env ruby

require_relative 'trimp_calculator'

ENTRENO = Struct.new(:description, :duration, :avg_hr, :max_hr)

resting_hr = 55
gender = :male

entrenos = [
  ENTRENO.new('Marismas Blancas - Sprint', 48, 148, 169),
  ENTRENO.new('4x4', 64, 135, 168),
  ENTRENO.new('Entrenamiento en cinta', 45, 129, 146),
  ENTRENO.new('Km Vertical Matienzo de bajada', 23, 150, 159),
  ENTRENO.new('Km Vertical Matienzo', 42, 166, 174),
  ENTRENO.new('Cardio', 60, 98, 121)
]

resultados = []

entrenos.each_with_index do |entreno, index|
  calculator = TRIMPCalculator.new(entreno.duration, entreno.avg_hr, entreno.max_hr, resting_hr, gender)
  trimp = calculator.calculate
  resultados << trimp
  puts "  TRIMP Score: #{trimp}"
end

puts "\n=== Summary ==="
resultados.sum.tap do |total_trimp|
  puts "Total TRIMP Score: #{total_trimp.round(2)}"
  
  # Classify the weekly TRIMP
  classification = TRIMPCalculator.classify_trimp(total_trimp)
  puts "Weekly Range: #{classification[:range]}"
  puts "Interpretation: #{classification[:interpretation]}"
  puts "Phase: #{TRIMPCalculator.classify_training_phase(total_trimp)[:phase]}"
end



