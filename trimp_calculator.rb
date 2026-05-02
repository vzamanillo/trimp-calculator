#!/usr/bin/env ruby

# TRIMP (Training Impulse) Calculator
# TRIMP = Duration (minutes) × Average HR intensity factor × Gender factor
# Intensity factor = (Average HR - Resting HR) / (Max HR - Resting HR)

class TRIMPCalculator
  GENDER_FACTORS = {
    male: 1.0,
    female: 0.86
  }.freeze

  def initialize(duration_minutes, avg_heart_rate, max_heart_rate, resting_heart_rate, gender = :male)
    @duration = duration_minutes
    @avg_hr = avg_heart_rate
    @max_hr = max_heart_rate
    @resting_hr = resting_heart_rate
    @gender = gender.downcase.to_sym
    
    validate_inputs
  end

  def calculate
    intensity_factor = (@avg_hr - @resting_hr).to_f / (@max_hr - @resting_hr)
    gender_factor = GENDER_FACTORS[@gender]
    
    trimp = @duration * intensity_factor * gender_factor
    trimp.round(2)
  end

  private

  def validate_inputs
    raise ArgumentError, "Duration must be positive" if @duration <= 0
    raise ArgumentError, "Average HR must be positive" if @avg_hr <= 0
    raise ArgumentError, "Max HR must be positive" if @max_hr <= 0
    raise ArgumentError, "Resting HR must be positive" if @resting_hr <= 0
    raise ArgumentError, "Average HR must be less than Max HR" if @avg_hr > @max_hr
    raise ArgumentError, "Resting HR must be less than Max HR" if @resting_hr >= @max_hr
    raise ArgumentError, "Invalid gender. Use :male or :female" unless GENDER_FACTORS.key?(@gender)
  end
end

# Example usage
if __FILE__ == $0
  puts "=== TRIMP Calculator ==="
  puts
  
  # Example 1: Male athlete
  duration = 60  # 60 minutes
  avg_hr = 150
  max_hr = 200
  resting_hr = 60
  gender = :male
  
  calculator = TRIMPCalculator.new(duration, avg_hr, max_hr, resting_hr, gender)
  trimp = calculator.calculate
  
  puts "Example 1 (Male):"
  puts "  Duration: #{duration} minutes"
  puts "  Average HR: #{avg_hr} bpm"
  puts "  Max HR: #{max_hr} bpm"
  puts "  Resting HR: #{resting_hr} bpm"
  puts "  Gender: #{gender}"
  puts "  TRIMP Score: #{trimp}"
  puts
  
  # Example 2: Female athlete
  calculator2 = TRIMPCalculator.new(45, 140, 195, 58, :female)
  trimp2 = calculator2.calculate
  
  puts "Example 2 (Female):"
  puts "  Duration: 45 minutes"
  puts "  Average HR: 140 bpm"
  puts "  Max HR: 195 bpm"
  puts "  Resting HR: 58 bpm"
  puts "  Gender: female"
  puts "  TRIMP Score: #{trimp2}"
end
