#!/usr/bin/env ruby

# TRIMP (Training Impulse) Calculator
# TRIMP = Duration (minutes) × Average HR intensity factor × Gender factor
# Intensity factor = (Average HR - Resting HR) / (Max HR - Resting HR)
#
# bTRIMP (Bannister's TRIMP) = Duration (minutes) × Intensity factor × e^(k × Intensity factor)
# where k is typically 1.92 for males and 1.67 for females
# Uses exponential weighting to emphasize high-intensity efforts

class TRIMPCalculator
  GENDER_FACTORS = {
    male: 1.0,
    female: 0.86
  }.freeze

  # bTRIMP exponential coefficients (higher values = more weight on intensity)
  BTRIP_COEFFICIENTS = {
    male: 1.92,
    female: 1.67
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

  # Calculate bTRIMP (Bannister's TRIMP)
  # Uses exponential model: Duration × Intensity × e^(k × Intensity)
  # Gives more weight to higher intensity efforts compared to linear TRIMP
  def calculate_btrip
    intensity_factor = (@avg_hr - @resting_hr).to_f / (@max_hr - @resting_hr)
    coefficient = BTRIP_COEFFICIENTS[@gender]
    
    # bTRIMP = Duration × Intensity × e^(k × Intensity)
    btrip = @duration * intensity_factor * Math.exp(coefficient * intensity_factor)
    btrip.round(2)
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

  # Classifies a bTRIMP value into a training intensity range
  # bTRIMP values are typically higher than linear TRIMP due to exponential weighting
  def self.classify_btrip(btrip_value)
    case btrip_value
    when 0...250
      { range: "< 250", interpretation: "Very light training week" }
    when 250...500
      { range: "250-500", interpretation: "Light training week" }
    when 500...900
      { range: "500-900", interpretation: "Moderate training week" }
    when 900...1500
      { range: "900-1500", interpretation: "Hard training week" }
    when 1500...2000
      { range: "1500-2000", interpretation: "Very hard training week" }
    else
      { range: "> 2000", interpretation: "Extreme training week (recovery needed)" }
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

  # Classifies a bTRIMP value into a training phase
  def self.classify_btrip_phase(btrip_value)
    case btrip_value
    when 0...500
      { phase: "Recovery phase", range: "< 500", description: "Deliberate rest weeks" }
    when 500...900
      { phase: "Base phase", range: "500-900", description: "Steady, consistent training" }
    when 900...1500
      { phase: "Build phase", range: "900-1500", description: "Increased intensity and volume" }
    else
      { phase: "Peak phase", range: "1500+", description: "High intensity" }
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
  puts "=== TRIMP & bTRIMP Calculator ==="
  puts
  
  # Example 1: Male athlete
  duration = 60  # 60 minutes
  avg_hr = 150
  max_hr = 200
  resting_hr = 60
  gender = :male
  
  calculator = TRIMPCalculator.new(duration, avg_hr, max_hr, resting_hr, gender)
  trimp = calculator.calculate
  btrip = calculator.calculate_btrip
  classification = TRIMPCalculator.classify_trimp(trimp)
  btrip_classification = TRIMPCalculator.classify_btrip(btrip)
  
  puts "Example 1 (Male):"
  puts "  Duration: #{duration} minutes"
  puts "  Average HR: #{avg_hr} bpm"
  puts "  Max HR: #{max_hr} bpm"
  puts "  Resting HR: #{resting_hr} bpm"
  puts "  Gender: #{gender}"
  puts "  TRIMP Score: #{trimp}"
  puts "  bTRIMP Score: #{btrip}"
  puts "  TRIMP Range: #{classification[:range]} - #{classification[:interpretation]}"
  puts "  bTRIMP Range: #{btrip_classification[:range]} - #{btrip_classification[:interpretation]}"
  puts
  
  # Example 2: Female athlete
  calculator2 = TRIMPCalculator.new(45, 140, 195, 58, :female)
  trimp2 = calculator2.calculate
  btrip2 = calculator2.calculate_btrip
  classification2 = TRIMPCalculator.classify_trimp(trimp2)
  btrip_classification2 = TRIMPCalculator.classify_btrip(btrip2)
  
  puts "Example 2 (Female):"
  puts "  Duration: 45 minutes"
  puts "  Average HR: 140 bpm"
  puts "  Max HR: 195 bpm"
  puts "  Resting HR: 58 bpm"
  puts "  Gender: female"
  puts "  TRIMP Score: #{trimp2}"
  puts "  bTRIMP Score: #{btrip2}"
  puts "  TRIMP Range: #{classification2[:range]} - #{classification2[:interpretation]}"
  puts "  bTRIMP Range: #{btrip_classification2[:range]} - #{btrip_classification2[:interpretation]}"
  puts
  
  # Example 3: Comparing TRIMP vs bTRIMP at different intensities
  puts "Example 3 (TRIMP vs bTRIMP comparison for 60 min at various intensities):"
  test_hr_values = [120, 140, 160, 180]
  test_hr_values.each do |avg_hr_test|
    calc = TRIMPCalculator.new(60, avg_hr_test, 200, 60, :male)
    trimp_val = calc.calculate
    btrip_val = calc.calculate_btrip
    intensity = ((avg_hr_test - 60).to_f / (200 - 60) * 100).round(1)
    puts "  #{intensity}% intensity (#{avg_hr_test} bpm): TRIMP=#{trimp_val}, bTRIMP=#{btrip_val}"
  end
end
