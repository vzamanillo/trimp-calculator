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

  # Classifies a TRIMP value into a training intensity range
  # Returns a hash with :range and :interpretation
  # Can be used as a class method: TRIMPCalculator.classify_trimp(value)
  def self.classify_trimp(trimp_value)
    case trimp_value
    when 0...150
      { range: "< 150", interpretation: "Very light training week" }
    when 150...300
      { range: "150-300", interpretation: "Light training week" }
    when 300...500
      { range: "300-500", interpretation: "Moderate training week" }
    when 500...750
      { range: "500-750", interpretation: "Hard training week" }
    when 750...1000
      { range: "750-1000", interpretation: "Very hard training week" }
    else
      { range: "> 1000", interpretation: "Extreme training week (recovery needed)" }
    end
  end

  # Classifies a TRIMP value into a training phase
  # Returns a hash with :phase, :range, and :description
  # Can be used as a class method: TRIMPCalculator.classify_training_phase(value)
  def self.classify_training_phase(trimp_value)
    case trimp_value
    when 0...300
      { phase: "Recovery phase", range: "< 300", description: "Deliberate rest weeks" }
    when 300...500
      { phase: "Base phase", range: "300-500", description: "Steady, consistent training" }
    when 500...750
      { phase: "Build phase", range: "500-750", description: "Increased intensity and volume" }
    else
      { phase: "Peak phase", range: "750-1000+", description: "High intensity" }
    end
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
  classification = TRIMPCalculator.classify_trimp(trimp)
  
  puts "Example 1 (Male):"
  puts "  Duration: #{duration} minutes"
  puts "  Average HR: #{avg_hr} bpm"
  puts "  Max HR: #{max_hr} bpm"
  puts "  Resting HR: #{resting_hr} bpm"
  puts "  Gender: #{gender}"
  puts "  TRIMP Score: #{trimp}"
  puts "  Range: #{classification[:range]}"
  puts "  Interpretation: #{classification[:interpretation]}"
  puts
  
  # Example 2: Female athlete
  calculator2 = TRIMPCalculator.new(45, 140, 195, 58, :female)
  trimp2 = calculator2.calculate
  classification2 = TRIMPCalculator.classify_trimp(trimp2)
  
  puts "Example 2 (Female):"
  puts "  Duration: 45 minutes"
  puts "  Average HR: 140 bpm"
  puts "  Max HR: 195 bpm"
  puts "  Resting HR: 58 bpm"
  puts "  Gender: female"
  puts "  TRIMP Score: #{trimp2}"
  puts "  Range: #{classification2[:range]}"
  puts "  Interpretation: #{classification2[:interpretation]}"
  puts
  
  # Example 3: Testing with different TRIMP values
  puts "Example 3 (Range Classification for various TRIMP values):"
  test_values = [100, 200, 400, 600, 850, 1200]
  test_values.each do |value|
    classification = TRIMPCalculator.classify_trimp(value)
    puts "  TRIMP #{value}: #{classification[:interpretation]}"
  end
end
