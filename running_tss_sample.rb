#!/usr/bin/env ruby

require_relative 'running_tss_calculator'

puts "Weekly TSS Summary"
workouts = [
  { name: "Marismas Blancas - Sprint", duration: 48, avg_hr: 148 },
  { name: "4x4", duration: 64, avg_hr: 135 },
  { name: "Entrenamiento en cinta", duration: 45, avg_hr: 129 },
  { name: "Km Vertical Matienzo", duration: 42, avg_hr: 166 },
  { name: "Km Vertical Matienzo de bajada", duration: 23, avg_hr: 150 },
  { name: "Cardio", duration: 60, avg_hr: 98 }
]

lthr = 156.4 # LTHR para el corredor 85% de 184 bpm
weekly_tss = 0

workouts.each do |workout|
  calc = RunningTSSCalculator.new(workout[:duration], workout[:avg_hr], lthr, :male)
  tss = calc.calculate_tss
  weekly_tss += tss
  puts "  #{workout[:name]}: TSS = #{tss}"
end

puts "  ---"
puts "  Weekly Total TSS: #{weekly_tss.round(2)}"
weekly_classification = RunningTSSCalculator.classify_tss_weekly(weekly_tss)
puts "  Interpretation: #{weekly_classification[:interpretation]}"
puts "  Training Phase: #{weekly_classification[:training_phase]}"
puts "  Recommendation: #{weekly_classification[:recommendation]}"