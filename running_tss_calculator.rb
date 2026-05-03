#!/usr/bin/env ruby

# TSS (Training Stress Score) Calculator for Running
# TSS is adapted from cycling methodology to work with running using heart rate
#
# TSS = (Duration (minutes) × Intensity Factor²) / 100
# where Intensity Factor = Average HR / Lactate Threshold HR (LTHR)
#
# This method is ideal for runners who want to quantify training stress
# similar to how cyclists use power-based TSS calculations

class RunningTSSCalculator
  def initialize(duration_minutes, avg_heart_rate, lactate_threshold_hr)
    @duration = duration_minutes
    @avg_hr = avg_heart_rate
    @lthr = lactate_threshold_hr
    
    validate_inputs
  end

  # Calculate TSS (Training Stress Score)
  # Formula: TSS = (Duration × Intensity Factor²)
  # where Intensity Factor = Average HR / LTHR
  def calculate_tss
    tss = @duration * (intensity_factor ** 2)
    tss.round(2)
  end

  # Get intensity factor for reference
  def intensity_factor
    (@avg_hr.to_f / @lthr).round(3)
  end

  # Classify a single workout TSS value
  # Returns a hash with :range, :interpretation, and :zone
  def self.classify_tss_workout(tss_value)
    case tss_value
    when 0...50
      { range: "< 50", interpretation: "Easy workout", zone: 1 }
    when 50...100
      { range: "50-100", interpretation: "Moderate workout", zone: 2 }
    when 100...150
      { range: "100-150", interpretation: "Hard workout", zone: 3 }
    when 150...200
      { range: "150-200", interpretation: "Very hard workout", zone: 4 }
    else
      { range: "> 200", interpretation: "Race effort / Max intensity", zone: 5 }
    end
  end

  # Classify weekly TSS for running training load
  # Returns a hash with :range, :interpretation, and :training_phase
  def self.classify_tss_weekly(weekly_tss)
    case weekly_tss
    when 0...100
      { 
        range: "< 100", 
        interpretation: "Very light training week", 
        training_phase: "Recovery phase",
        recommendation: "Mostly easy runs, focus on recovery"
      }
    when 100...250
      { 
        range: "100-250", 
        interpretation: "Light training week", 
        training_phase: "Recovery/Base phase",
        recommendation: "Easy runs with one moderate session"
      }
    when 250...400
      { 
        range: "250-400", 
        interpretation: "Moderate training week", 
        training_phase: "Base building phase",
        recommendation: "Mix of easy runs and 1-2 moderate sessions"
      }
    when 400...550
      { 
        range: "400-550", 
        interpretation: "Hard training week", 
        training_phase: "Build phase",
        recommendation: "Mix of easy, moderate, and one hard session"
      }
    when 550...700
      { 
        range: "550-700", 
        interpretation: "Very hard training week", 
        training_phase: "Peak training phase",
        recommendation: "High volume with 2-3 intense sessions"
      }
    else
      { 
        range: "> 700", 
        interpretation: "Extreme training week", 
        training_phase: "Peak/Race week or overtraining risk",
        recommendation: "Consider recovery week next. Monitor fatigue closely."
      }
    end
  end

  # Get heart rate zone information for the run
  def get_hr_zone_info
    hr_percent = (@avg_hr.to_f / @lthr) * 100
    
    zone_info = case hr_percent
                when 0...85
                  { zone: 1, name: "Recovery", color: "Blue" }
                when 85...100
                  { zone: 2, name: "Aerobic (Moderate)", color: "Green" }
                when 100...115
                  { zone: 3, name: "Tempo/Threshold", color: "Yellow" }
                else
                  { zone: 4, name: "VO2 Max/Hard", color: "Red" }
                end
    
    zone_info.merge({
      hr_percent_of_lthr: hr_percent.round(1),
      avg_hr: @avg_hr,
      lthr: @lthr
    })
  end

  # Get detailed workout analysis
  def get_workout_analysis
    tss = calculate_tss
    classification = self.class.classify_tss_workout(tss)
    zone_info = get_hr_zone_info
    
    {
      duration: @duration,
      avg_hr: @avg_hr,
      lthr: @lthr,
      intensity_factor: intensity_factor,
      tss: tss,
      classification: classification,
      zone_info: zone_info
    }
  end

  private

  def validate_inputs
    raise ArgumentError, "Duration must be positive" if @duration <= 0
    raise ArgumentError, "Average HR must be positive" if @avg_hr <= 0
    raise ArgumentError, "Lactate Threshold HR must be positive" if @lthr <= 0
    raise ArgumentError, "Average HR must be less than or equal to LTHR for sustainable effort. For max efforts > LTHR, use 1.0+ intensity factor." if @avg_hr > @lthr * 1.2
  end
end

# Example usage
if __FILE__ == $0
  puts "=== Running TSS Calculator Examples ==="
  puts
  
  # Example 1: Easy recovery run
  puts "Example 1: Easy Recovery Run"
  calc1 = RunningTSSCalculator.new(30, 130, 160)
  analysis1 = calc1.get_workout_analysis
  
  puts "  Duration: #{analysis1[:duration]} minutes"
  puts "  Average HR: #{analysis1[:avg_hr]} bpm"
  puts "  Lactate Threshold HR: #{analysis1[:lthr]} bpm"
  puts "  Intensity Factor: #{analysis1[:intensity_factor]}"
  puts "  TSS: #{analysis1[:tss]}"
  puts "  Zone: #{analysis1[:zone_info][:name]} (#{analysis1[:zone_info][:hr_percent_of_lthr]}% of LTHR)"
  puts "  Classification: #{analysis1[:classification][:interpretation]}"
  puts
  
  # Example 2: Moderate tempo run
  puts "Example 2: Tempo Run (Sustained Effort)"
  calc2 = RunningTSSCalculator.new(40, 155, 160)
  analysis2 = calc2.get_workout_analysis
  
  puts "  Duration: #{analysis2[:duration]} minutes"
  puts "  Average HR: #{analysis2[:avg_hr]} bpm"
  puts "  Lactate Threshold HR: #{analysis2[:lthr]} bpm"
  puts "  Intensity Factor: #{analysis2[:intensity_factor]}"
  puts "  TSS: #{analysis2[:tss]}"
  puts "  Zone: #{analysis2[:zone_info][:name]} (#{analysis2[:zone_info][:hr_percent_of_lthr]}% of LTHR)"
  puts "  Classification: #{analysis2[:classification][:interpretation]}"
  puts
  
  # Example 3: Hard interval session
  puts "Example 3: Hard Interval Session"
  calc3 = RunningTSSCalculator.new(50, 170, 160)
  analysis3 = calc3.get_workout_analysis
  
  puts "  Duration: #{analysis3[:duration]} minutes"
  puts "  Average HR: #{analysis3[:avg_hr]} bpm"
  puts "  Lactate Threshold HR: #{analysis3[:lthr]} bpm"
  puts "  Intensity Factor: #{analysis3[:intensity_factor]}"
  puts "  TSS: #{analysis3[:tss]}"
  puts "  Zone: #{analysis3[:zone_info][:name]} (#{analysis3[:zone_info][:hr_percent_of_lthr]}% of LTHR)"
  puts "  Classification: #{analysis3[:classification][:interpretation]}"
  puts
  
  # Example 4: Weekly TSS summary
  puts "Example 4: Weekly TSS Summary"
  workouts = [
    { name: "Monday Easy Run", duration: 30, avg_hr: 130 },
    { name: "Tuesday Tempo", duration: 40, avg_hr: 155 },
    { name: "Wednesday Recovery", duration: 35, avg_hr: 125 },
    { name: "Thursday Long Run", duration: 90, avg_hr: 140 },
    { name: "Friday Easy", duration: 30, avg_hr: 128 },
    { name: "Saturday Hard", duration: 50, avg_hr: 170 }
  ]
  
  lthr = 160
  weekly_tss = 0
  
  workouts.each do |workout|
    calc = RunningTSSCalculator.new(workout[:duration], workout[:avg_hr], lthr)
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
end
