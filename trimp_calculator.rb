#!/usr/bin/env ruby

# TRIMP (Training Impulse) Calculator
# TRIMP = Duration (minutes) × Average HR intensity factor × Gender factor
# Intensity factor = (Average HR - Resting HR) / (Max HR - Resting HR)
#
# bTRIMP (Bannister's TRIMP) = Duration (minutes) × Intensity factor × e^(k × Intensity factor)
# where k is typically 1.92 for males and 1.67 for females
# Uses exponential weighting to emphasize high-intensity efforts
#
# eTRIMP (Edwards' TRIMP) = Sum of (Minutes in zone × Zone multiplier)
# Uses 5 heart rate zones with increasing multipliers for higher intensities
# Most accurate for multi-zone training analysis

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

  # eTRIMP zone multipliers (Edwards' method)
  # Based on % of max HR: Z1(50-60%), Z2(60-70%), Z3(70-80%), Z4(80-90%), Z5(90-100%)
  ETRIP_ZONE_MULTIPLIERS = [1, 2, 3, 4, 5].freeze

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
  def calculate_btrimp
    intensity_factor = (@avg_hr - @resting_hr).to_f / (@max_hr - @resting_hr)
    coefficient = BTRIP_COEFFICIENTS[@gender]
    
    # bTRIMP = Duration × Intensity × e^(k × Intensity)
    btrip = @duration * intensity_factor * Math.exp(coefficient * intensity_factor)
    btrip.round(2)
  end

  # Calculate eTRIMP (Edwards' TRIMP)
  # Uses zone-based multipliers: assumes entire workout in single zone at avg_hr
  # Zone definitions based on % of max HR:
  # Z1: 50-60% (multiplier: 1)
  # Z2: 60-70% (multiplier: 2)
  # Z3: 70-80% (multiplier: 3)
  # Z4: 80-90% (multiplier: 4)
  # Z5: 90-100% (multiplier: 5)
  def calculate_etrimp
    # Calculate HR as % of max HR
    hr_percent = (@avg_hr.to_f / @max_hr) * 100
    
    # Determine zone multiplier
    zone_multiplier = case hr_percent
                      when 0...50
                        0  # Below zone
                      when 50...60
                        1  # Z1
                      when 60...70
                        2  # Z2
                      when 70...80
                        3  # Z3
                      when 80...90
                        4  # Z4
                      else
                        5  # Z5
                      end
    
    etrip = @duration * zone_multiplier
    etrip.round(2)
  end

  # Calculate eTRIMP with detailed zone breakdown (for mixed-zone workouts)
  # Accepts a hash of zone distributions: { z1: 10, z2: 20, z3: 15, z4: 10, z5: 5 }
  # where keys are zone names and values are minutes in each zone
  def calculate_etrimp_detailed(zone_minutes)
    total_etrip = 0
    zone_multipliers = { z1: 1, z2: 2, z3: 3, z4: 4, z5: 5 }
    
    zone_minutes.each do |zone, minutes|
      multiplier = zone_multipliers[zone]
      total_etrip += minutes * multiplier if multiplier
    end
    
    total_etrip.round(2)
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
  def self.classify_btrimp(btrip_value)
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

  # Classifies an eTRIMP value into a training intensity range
  # eTRIMP scales differently based on zone distribution
  def self.classify_etrimp(etrip_value)
    case etrip_value
    when 0...50
      { range: "< 50", interpretation: "Very light training week" }
    when 50...150
      { range: "50-150", interpretation: "Light training week" }
    when 150...300
      { range: "150-300", interpretation: "Moderate training week" }
    when 300...450
      { range: "300-450", interpretation: "Hard training week" }
    when 450...600
      { range: "450-600", interpretation: "Very hard training week" }
    else
      { range: "> 600", interpretation: "Extreme training week (recovery needed)" }
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
  def self.classify_training_phase_btrimp(btrip_value)
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

  # Classifies an eTRIMP value into a training phase
  def self.classify_training_phase_etrimp(etrip_value)
    case etrip_value
    when 0...100
      { phase: "Recovery phase", range: "< 100", description: "Deliberate rest weeks" }
    when 100...200
      { phase: "Base phase", range: "100-200", description: "Steady, consistent training" }
    when 200...350
      { phase: "Build phase", range: "200-350", description: "Increased intensity and volume" }
    else
      { phase: "Peak phase", range: "350+", description: "High intensity" }
    end
  end

  # Get HR zone information based on average HR
  def get_zone_info
    hr_percent = (@avg_hr.to_f / @max_hr) * 100
    
    zone = case hr_percent
           when 0...50
             { zone: 0, name: "Below Z1", color: "Gray" }
           when 50...60
             { zone: 1, name: "Z1 (Recovery)", color: "Gray" }
           when 60...70
             { zone: 2, name: "Z2 (Endurance)", color: "Blue" }
           when 70...80
             { zone: 3, name: "Z3 (Tempo)", color: "Green" }
           when 80...90
             { zone: 4, name: "Z4 (Threshold)", color: "Yellow" }
           else
             { zone: 5, name: "Z5 (VO2 Max)", color: "Red" }
           end
    
    zone.merge({
      hr_percent: hr_percent.round(1),
      avg_hr: @avg_hr,
      max_hr: @max_hr
    })
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
  puts "=== TRIMP, bTRIMP & eTRIMP Calculator ==="
  puts
  
  # Example 1: Male athlete
  duration = 60  # 60 minutes
  avg_hr = 150
  max_hr = 200
  resting_hr = 60
  gender = :male
  
  calculator = TRIMPCalculator.new(duration, avg_hr, max_hr, resting_hr, gender)
  trimp = calculator.calculate
  btrip = calculator.calculate_btrimp
  etrip = calculator.calculate_etrimp
  zone_info = calculator.get_zone_info
  
  classification = TRIMPCalculator.classify_trimp(trimp)
  btrip_classification = TRIMPCalculator.classify_btrimp(btrip)
  etrip_classification = TRIMPCalculator.classify_etrimp(etrip)
  
  puts "Example 1 (Male - 60 min @ 150 bpm):"
  puts "  Duration: #{duration} minutes"
  puts "  Average HR: #{avg_hr} bpm (#{zone_info[:hr_percent]}% of max)"
  puts "  Zone: #{zone_info[:name]}"
  puts "  Max HR: #{max_hr} bpm"
  puts "  Resting HR: #{resting_hr} bpm"
  puts "  Gender: #{gender}"
  puts "  TRIMP Score: #{trimp} - #{classification[:interpretation]}"
  puts "  bTRIMP Score: #{btrip} - #{btrip_classification[:interpretation]}"
  puts "  eTRIMP Score: #{etrip} - #{etrip_classification[:interpretation]}"
  puts
  
  # Example 2: Female athlete
  calculator2 = TRIMPCalculator.new(45, 140, 195, 58, :female)
  trimp2 = calculator2.calculate
  btrip2 = calculator2.calculate_btrimp
  etrip2 = calculator2.calculate_etrimp
  zone_info2 = calculator2.get_zone_info
  
  classification2 = TRIMPCalculator.classify_trimp(trimp2)
  btrip_classification2 = TRIMPCalculator.classify_btrimp(btrip2)
  etrip_classification2 = TRIMPCalculator.classify_etrimp(etrip2)
  
  puts "Example 2 (Female - 45 min @ 140 bpm):"
  puts "  Duration: 45 minutes"
  puts "  Average HR: 140 bpm (#{zone_info2[:hr_percent]}% of max)"
  puts "  Zone: #{zone_info2[:name]}"
  puts "  Max HR: 195 bpm"
  puts "  Resting HR: 58 bpm"
  puts "  Gender: female"
  puts "  TRIMP Score: #{trimp2} - #{classification2[:interpretation]}"
  puts "  bTRIMP Score: #{btrip2} - #{btrip_classification2[:interpretation]}"
  puts "  eTRIMP Score: #{etrip2} - #{etrip_classification2[:interpretation]}"
  puts
  
  # Example 3: Comparing all three methods at different intensities
  puts "Example 3 (TRIMP vs bTRIMP vs eTRIMP for 60 min at various intensities):"
  puts "  Intensity | Zone  | TRIMP  | bTRIMP | eTRIMP"
  puts "  --------  | ----- | ------ | ------ | ------"
  test_hr_values = [120, 140, 160, 180]
  test_hr_values.each do |avg_hr_test|
    calc = TRIMPCalculator.new(60, avg_hr_test, 200, 60, :male)
    trimp_val = calc.calculate
    btrip_val = calc.calculate_btrimp
    etrip_val = calc.calculate_etrimp
    zone_info_test = calc.get_zone_info
    intensity = ((avg_hr_test - 60).to_f / (200 - 60) * 100).round(1)
    puts "  #{intensity}%        | Z#{zone_info_test[:zone]}    | #{trimp_val.to_s.rjust(6)} | #{btrip_val.to_s.rjust(6)} | #{etrip_val.to_s.rjust(6)}"
  end
  puts
  
  # Example 4: eTRIMP with mixed zones (detailed calculation)
  puts "Example 4 (eTRIMP with mixed zones - 90 min workout):"
  zone_distribution = { z1: 15, z2: 30, z3: 25, z4: 15, z5: 5 }
  puts "  Zone Distribution:"
  zone_distribution.each do |zone, minutes|
    multiplier = { z1: 1, z2: 2, z3: 3, z4: 4, z5: 5 }[zone]
    puts "    #{zone.to_s.upcase}: #{minutes} min × #{multiplier} = #{minutes * multiplier}"
  end
  
  calc_detailed = TRIMPCalculator.new(90, 150, 200, 60, :male)
  etrip_detailed = calc_detailed.calculate_etrimp_detailed(zone_distribution)
  etrip_class = TRIMPCalculator.classify_etrimp(etrip_detailed)
  puts "  Total eTRIMP: #{etrip_detailed} - #{etrip_class[:interpretation]}"
end
